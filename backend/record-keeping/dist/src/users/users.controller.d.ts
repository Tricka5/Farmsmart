import { UsersService } from './users.service';
import { selectUsers } from 'src/db/schema';
import { OtpService } from 'src/otp/otp.service';
import { FirstNameDto } from './dto/updateFirstName.dto';
import { lastNameDto } from './dto/updateLastName.dto';
import { profilePictureNameDto } from './dto/updateProfilePicture.dto';
export declare class UsersController {
    private readonly usersService;
    private readonly otpService;
    constructor(usersService: UsersService, otpService: OtpService);
    getAllUsers(): Promise<selectUsers[]>;
    getUserById(userid: string): Promise<{
        password: string;
        userid: number;
        firstname: string;
        lastname: string;
        profilepicture: string;
        email: string;
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
        result: {
            access_token: string;
        };
        user: {
            password: string;
            userid: number;
            firstname: string;
            lastname: string;
            profilepicture: string;
            email: string;
            activationstatus: boolean;
        };
    }>;
    getProfile(req: any): any;
    updateFirstName(updateFirstNameDto: FirstNameDto): Promise<{
        message: string;
        updatedRows: number;
    }>;
    updateLastName(updateFirstNameDto: lastNameDto): Promise<{
        message: string;
        updatedRows: number;
    }>;
    updateProfilepicture(updateFirstNameDto: profilePictureNameDto): Promise<{
        message: string;
        updatedRows: number;
    }>;
}
