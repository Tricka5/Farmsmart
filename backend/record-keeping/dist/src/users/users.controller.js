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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersController = void 0;
const common_1 = require("@nestjs/common");
const users_service_1 = require("./users.service");
const auth_guard_1 = require("./auth.guard");
const otp_service_1 = require("../otp/otp.service");
const updateFirstName_dto_1 = require("./dto/updateFirstName.dto");
const updateLastName_dto_1 = require("./dto/updateLastName.dto");
const updateProfilePicture_dto_1 = require("./dto/updateProfilePicture.dto");
let UsersController = class UsersController {
    constructor(usersService, otpService) {
        this.usersService = usersService;
        this.otpService = otpService;
    }
    async getAllUsers() {
        return await this.usersService.getAllUsers();
    }
    async getUserById(userid) {
        const user_id = Number(userid);
        const user = await this.usersService.getUserById(user_id);
        if (!user) {
            throw new common_1.HttpException(`User ${user_id} not found`, common_1.HttpStatus.NOT_FOUND);
        }
        return user;
    }
    async sendOtp(email) {
        try {
            await this.otpService.sendOtpToEmail(email);
            return 'OTP sent successfully!';
        }
        catch (error) {
            throw new common_1.BadRequestException('Failed to send OTP');
        }
    }
    async verifyOtp(email, otp) {
        const result = await this.otpService.verifyOtp(email, otp);
        return result;
    }
    async createUser(createUserDtotwo) {
        const { firstname, lastname, profilepicture, email, password } = createUserDtotwo;
        const result = await this.usersService.createUser(firstname, lastname, profilepicture, email, password);
        return result;
    }
    async login(LoginDto) {
        console.log('Login attempt for:', LoginDto.email);
        const { email, password } = LoginDto;
        const result = await this.usersService.getAuthenticatedUser(email, password);
        const user = await this.usersService.getUserByEmail(email);
        const damdata = { result, user };
        return { result, user };
    }
    getProfile(req) {
        return req.user;
    }
    async updateFirstName(updateFirstNameDto) {
        try {
            const { email, firstname } = updateFirstNameDto;
            const result = await this.usersService.updateFirstName(updateFirstNameDto.email, updateFirstNameDto.firstname);
            return result;
        }
        catch (error) {
            throw new Error('Failed to update first name. Please try again later.');
        }
    }
    async updateLastName(updateFirstNameDto) {
        try {
            const { email, lastname } = updateFirstNameDto;
            const result = await this.usersService.updateLastName(updateFirstNameDto.email, updateFirstNameDto.lastname);
            return result;
        }
        catch (error) {
            throw new Error('Failed to update lastname name. Please try again later.');
        }
    }
    async updateProfilepicture(updateFirstNameDto) {
        try {
            const { email, profilePicture } = updateFirstNameDto;
            const result = await this.usersService.updateProfilePicture(updateFirstNameDto.email, updateFirstNameDto.profilePicture);
            return result;
        }
        catch (error) {
            throw new Error('Failed to update profile. Please try again later.');
        }
    }
};
exports.UsersController = UsersController;
__decorate([
    (0, common_1.Get)('allusers'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "getAllUsers", null);
__decorate([
    (0, common_1.Get)(':userid'),
    __param(0, (0, common_1.Param)('userid')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "getUserById", null);
__decorate([
    (0, common_1.Post)('otp/send'),
    __param(0, (0, common_1.Body)('email')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "sendOtp", null);
__decorate([
    (0, common_1.Post)('otp/verify'),
    __param(0, (0, common_1.Body)('email')),
    __param(1, (0, common_1.Body)('otp')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "verifyOtp", null);
__decorate([
    (0, common_1.Post)('createuser'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "createUser", null);
__decorate([
    (0, common_1.Post)('login'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "login", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Get)('profile'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "getProfile", null);
__decorate([
    (0, common_1.Put)('updatefirstname'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [updateFirstName_dto_1.FirstNameDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateFirstName", null);
__decorate([
    (0, common_1.Put)('updatelastname'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [updateLastName_dto_1.lastNameDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateLastName", null);
__decorate([
    (0, common_1.Put)('updateprofilepicture'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [updateProfilePicture_dto_1.profilePictureNameDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateProfilepicture", null);
exports.UsersController = UsersController = __decorate([
    (0, common_1.Controller)('users'),
    __metadata("design:paramtypes", [users_service_1.UsersService,
        otp_service_1.OtpService])
], UsersController);
//# sourceMappingURL=users.controller.js.map