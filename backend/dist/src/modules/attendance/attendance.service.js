"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AttendanceService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
const geo_util_1 = require("../../common/utils/geo.util");
let AttendanceService = class AttendanceService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async checkIn(dto) {
        if (dto.accuracy > 20) {
            throw new common_1.BadRequestException('GPS accuracy is too low. Move to a clearer area.');
        }
        const office = await this.prisma.officeLocation.findUnique({
            where: { id: dto.officeId },
        });
        if (!office) {
            throw new common_1.NotFoundException('Office location not found');
        }
        const distanceInMeters = (0, geo_util_1.calculateDistance)(dto.latitude, dto.longitude, office.latitude, office.longitude);
        if (distanceInMeters > office.radius) {
            throw new common_1.BadRequestException(`You are ${distanceInMeters.toFixed(1)}m away. You must be within ${office.radius}m of the office.`);
        }
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const existingAttendance = await this.prisma.attendance.findFirst({
            where: {
                userId: dto.userId,
                checkInTime: { gte: today },
            },
        });
        if (existingAttendance && !existingAttendance.checkOutTime) {
            throw new common_1.BadRequestException('You are already checked in. Please check out first.');
        }
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
    async checkOut(dto) {
        const attendance = await this.prisma.attendance.findUnique({
            where: { id: dto.attendanceId },
        });
        if (!attendance) {
            throw new common_1.NotFoundException('Attendance record not found');
        }
        if (attendance.checkOutTime) {
            throw new common_1.BadRequestException('Already checked out');
        }
        const checkOutTime = new Date();
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
};
exports.AttendanceService = AttendanceService;
exports.AttendanceService = AttendanceService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AttendanceService);
//# sourceMappingURL=attendance.service.js.map