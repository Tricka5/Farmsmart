import { EmailService } from 'src/email/email.service';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';
export declare class OtpService {
    private emailService;
    private jwtService;
    private userService;
    private otpStore;
    private readonly logger;
    constructor(emailService: EmailService, jwtService: JwtService, userService: UsersService);
    sendOtpToEmail(email: string): Promise<void>;
    verifyOtp(email: string, enteredOtp: string): Promise<any>;
    private generateAccessToken;
}
