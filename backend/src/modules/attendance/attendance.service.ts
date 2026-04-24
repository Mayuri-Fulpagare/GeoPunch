import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CheckInDto, CheckOutDto } from './dto/attendance.dto';
import { calculateDistance } from '../../common/utils/geo.util';

@Injectable()
export class AttendanceService {
  constructor(private prisma: PrismaService) {}

  async checkIn(dto: CheckInDto) {
    // 1. Validate Accuracy
    if (dto.accuracy > 20) {
      throw new BadRequestException('GPS accuracy is too low. Move to a clearer area.');
    }

    // 2. Fetch Office Location
    const office = await this.prisma.officeLocation.findUnique({
      where: { id: dto.officeId },
    });

    if (!office) {
      throw new NotFoundException('Office location not found');
    }

    // 3. Calculate distance using Haversine
    const distanceInMeters = calculateDistance(
      dto.latitude, dto.longitude,
      office.latitude, office.longitude,
    );

    // 4. Check if within allowed radius
    if (distanceInMeters > office.radius) {
      throw new BadRequestException(`You are ${distanceInMeters.toFixed(1)}m away. You must be within ${office.radius}m of the office.`);
    }

    // 5. Check if already checked in today (prevent duplicate check-ins)
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const existingAttendance = await this.prisma.attendance.findFirst({
      where: {
        userId: dto.userId,
        checkInTime: { gte: today },
      },
    });

    if (existingAttendance && !existingAttendance.checkOutTime) {
      throw new BadRequestException('You are already checked in. Please check out first.');
    }

    // 6. Record Attendance
    const attendance = await this.prisma.attendance.create({
      data: {
        userId: dto.userId,
        checkInLat: dto.latitude,
        checkInLon: dto.longitude,
        accuracy: dto.accuracy,
        checkInTime: new Date(),
        status: 'PRESENT',
      },
    });

    return { message: 'Check-in successful', distance: distanceInMeters, attendance };
  }

  async checkOut(dto: CheckOutDto) {
    const attendance = await this.prisma.attendance.findUnique({
      where: { id: dto.attendanceId },
    });

    if (!attendance) {
      throw new NotFoundException('Attendance record not found');
    }
    if (attendance.checkOutTime) {
      throw new BadRequestException('Already checked out');
    }

    const checkOutTime = new Date();
    // Calculate working hours
    const diffMs = checkOutTime.getTime() - attendance.checkInTime.getTime();
    const workingHours = diffMs / (1000 * 60 * 60);

    const updated = await this.prisma.attendance.update({
      where: { id: dto.attendanceId },
      data: {
        checkOutTime,
        checkOutLat: dto.latitude,
        checkOutLon: dto.longitude,
        workingHours,
      },
    });

    return { message: 'Check-out successful', workingHours, attendance: updated };
  }
}
