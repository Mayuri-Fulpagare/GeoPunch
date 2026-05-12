import { Controller, Post, Body, Get, Query, Param } from '@nestjs/common';
import { AttendanceService } from '../services/attendance.service';
import { CheckInDto, CheckOutDto } from '../validators/attendance.dto';

@Controller('api/v1/attendance')
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post('check-in')
  checkIn(@Body() dto: CheckInDto) {
    return this.attendanceService.checkIn(dto);
  }

  @Post('check-out')
  checkOut(@Body() dto: CheckOutDto) {
    return this.attendanceService.checkOut(dto);
  }

  @Get('history/:userId')
  getHistory(
    @Param('userId') userId: string,
    @Query('month') month?: string,
    @Query('year') year?: string,
  ) {
    return this.attendanceService.getHistory(
      userId,
      month ? Number(month) : new Date().getMonth() + 1,
      year ? Number(year) : new Date().getFullYear(),
    );
  }
}
