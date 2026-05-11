import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CheckInDto {
  @IsNotEmpty()
  @IsString()
  userId: string; // Ideally this comes from JWT, but for testing we can accept it in body

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;

  @IsNumber()
  accuracy: number;

  @IsString()
  officeId: string;
}

export class CheckOutDto {
  @IsNotEmpty()
  @IsString()
  attendanceId: string;

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;
}
