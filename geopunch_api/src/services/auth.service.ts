import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { RegisterDto, LoginDto } from '../validators/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    console.log('Registration attempt for email:', dto.email);
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
    if (existingUser) {
      console.log('Registration failed: Email already registered:', dto.email);
      throw new ConflictException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    console.log('Password hashed successfully for:', dto.email);

    const user = await this.prisma.user.create({
      data: {
        name: dto.name,
        email: dto.email,
        passwordHash: hashedPassword,
      },
    });
    console.log('User created successfully:', {
      id: user.id,
      email: user.email,
      name: user.name,
    });

    const token = this.jwtService.sign({ sub: user.id, email: user.email });
    return {
      access_token: token,
      user: { id: user.id, name: user.name, email: user.email },
    };
  }

  async login(dto: LoginDto) {
    console.log('Login attempt for email:', dto.email);
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      console.log('Login failed: User not found for email:', dto.email);
      throw new NotFoundException('User not found');
    }

    console.log('User found in DB, verifying password...');

    const isPasswordValid = await bcrypt.compare(
      dto.password,
      user.passwordHash,
    );
    console.log('Password comparison result:', isPasswordValid);

    if (!isPasswordValid) {
      console.log('Login failed: Invalid password for email:', dto.email);
      throw new UnauthorizedException('Invalid password');
    }

    const token = this.jwtService.sign({ sub: user.id, email: user.email });
    console.log('Login successful for email:', dto.email);
    // eslint-disable-next-line prettier/prettier
    return { access_token: token, user: { id: user.id, name: user.name, email: user.email } };
  }
}
