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
var OtpService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.OtpService = void 0;
const common_1 = require("@nestjs/common");
const email_service_1 = require("../email/email.service");
const jwt_1 = require("@nestjs/jwt");
const users_service_1 = require("../users/users.service");
let OtpService = OtpService_1 = class OtpService {
    constructor(emailService, jwtService, userService) {
        this.emailService = emailService;
        this.jwtService = jwtService;
        this.userService = userService;
        this.otpStore = new Map();
        this.logger = new common_1.Logger(OtpService_1.name);
    }
    async sendOtpToEmail(email) {
        const otp = this.emailService.generateOtp();
        const expiresAt = Date.now() + 10 * 60 * 1000;
        this.logger.log(`Generated OTP for ${email}: ${otp}`);
        this.otpStore.set(email, { otp, expiresAt });
        this.logger.log(`Stored OTP for ${email}: ${JSON.stringify(this.otpStore.get(email))}`);
        await this.emailService.sendOtp(email, otp);
    }
    async verifyOtp(email, enteredOtp) {
        const otpData = this.otpStore.get(email);
        if (!otpData) {
            this.logger.warn(`No OTP found for ${email}`);
            throw new common_1.InternalServerErrorException('OTP not found or expired');
        }
        if (otpData.expiresAt < Date.now()) {
            this.otpStore.delete(email);
            this.logger.warn(`OTP for ${email} has expired`);
            throw new common_1.BadRequestException('OTP has expired');
        }
        this.logger.log(`Comparing OTPs for ${email}: enteredOtp=${enteredOtp}, storedOtp=${otpData.otp}`);
        if (otpData.otp !== enteredOtp) {
            this.otpStore.delete(email);
            this.logger.warn(`Invalid OTP entered for ${email}`);
            throw new common_1.BadRequestException('Invalid OTP');
        }
        this.otpStore.delete(email);
        this.logger.log(`OTP successfully verified for ${email}`);
        const result = await this.generateAccessToken(email);
        if (result) {
            const useractivation = await this.userService.updateActivationStatusByEmail(email, true);
            return this.userService.getUserByEmail(email);
        }
        return 'user unverified';
    }
    async generateAccessToken(email) {
        const user = await this.userService.getUserByEmail(email);
        if (!user) {
            throw new common_1.InternalServerErrorException('User not found');
        }
        const payload = {
            email: user.email,
            userId: user.userid,
        };
        const accessToken = this.jwtService.sign(payload, {
            secret: process.env.JWT_SECRET_KEY,
            expiresIn: '1h',
        });
        this.logger.log(`Access token generated for ${email}`);
        return accessToken;
    }
};
exports.OtpService = OtpService;
exports.OtpService = OtpService = OtpService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [email_service_1.EmailService,
        jwt_1.JwtService,
        users_service_1.UsersService])
], OtpService);
//# sourceMappingURL=otp.service.js.map