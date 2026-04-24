import { AttendanceService } from './attendance.service';
import { CheckInDto, CheckOutDto } from './dto/attendance.dto';
export declare class AttendanceController {
    private readonly attendanceService;
    constructor(attendanceService: AttendanceService);
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
