import { JwtService } from '@nestjs/jwt';
export declare class UserAunthenticationService {
    private jwtService;
    constructor(jwtService: JwtService);
    updateUserPassword(email: string, newPassword: string): Promise<any>;
}
