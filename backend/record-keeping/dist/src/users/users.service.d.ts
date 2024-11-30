import { selectUsers } from 'src/db/schema';
import { JwtService } from '@nestjs/jwt';
export declare class UsersService {
    private jwtService;
    constructor(jwtService: JwtService);
    getUserById(userId: selectUsers['userid']): Promise<selectUsers | null>;
    getUserByEmail(email: string): Promise<selectUsers | null>;
    getAllUsers(): Promise<selectUsers[] | null>;
    createUser(firstname: string, lastname: string, profilepicture: string, email: string, password: string): Promise<any>;
    getAuthenticatedUser(email: string, password: string): Promise<{
        access_token: string;
    }>;
    updateActivationStatusById(userId: number, activationStatus: boolean): Promise<void>;
    updateActivationStatusByEmail(email: string, activationStatus: boolean): Promise<void>;
    updateFirstName(email: string, firstname: string): Promise<{
        message: string;
        updatedRows: number;
    }>;
    updateLastName(email: string, lastname: string): Promise<{
        message: string;
        updatedRows: number;
    }>;
    updateProfilePicture(email: string, profilepicture: string): Promise<{
        message: string;
        updatedRows: number;
    }>;
}
