import { PrismaService } from '../../prisma/prisma.service';
import { CheckInDto, CheckOutDto } from './dto/attendance.dto';
export declare class AttendanceService {
    private prisma;
    constructor(prisma: PrismaService);
    checkIn(dto: CheckInDto): Promise<{
        message: string;
        distance: number;
        attendance: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            accuracy: number;
            checkInTime: Date;
            checkOutTime: Date | null;
            checkInLat: number;
            checkInLon: number;
            checkOutLat: number | null;
            checkOutLon: number | null;
            status: import("@prisma/client").$Enums.Status;
            workingHours: number | null;
        };
    }>;
    checkOut(dto: CheckOutDto): Promise<{
        message: string;
        workingHours: number;
        attendance: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            accuracy: number;
            checkInTime: Date;
            checkOutTime: Date | null;
            checkInLat: number;
            checkInLon: number;
            checkOutLat: number | null;
            checkOutLon: number | null;
            status: import("@prisma/client").$Enums.Status;
            workingHours: number | null;
        };
    }>;
}
