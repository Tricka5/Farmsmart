import { UsersService } from './users.service';
import { selectUsers } from 'src/db/schema';
import { OtpService } from 'src/otp/otp.service';
export declare class UsersController {
    private readonly usersService;
    private readonly otpService;
    constructor(usersService: UsersService, otpService: OtpService);
    getAllUsers(): Promise<selectUsers[]>;
    getUserById(userid: string): Promise<{
        userid: number;
        firstname: string;
        lastname: string;
        profilepicture: string;
        email: string;
        password: string;
        activationstatus: boolean;
    }>;
    sendOtp(email: string): Promise<string>;
    verifyOtp(email: string, otp: string): Promise<string>;
    createUser(createUserDtotwo: {
        firstname: string;
        lastname: string;
        profilepicture: string;
        email: string;
        password: string;
    }): Promise<selectUsers>;
    login(LoginDto: {
        email: string;
        password: string;
    }): Promise<{
        access_token: string;
    }>;
    getProfile(req: any): any;
}
