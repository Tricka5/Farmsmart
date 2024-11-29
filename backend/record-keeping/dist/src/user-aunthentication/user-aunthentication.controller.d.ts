import { UserAunthenticationService } from './user-aunthentication.service';
import { UpdatePasswordDto } from './dto/updatePassword.dto';
export declare class UserAunthenticationController {
    private readonly userAunthenticationService;
    constructor(userAunthenticationService: UserAunthenticationService);
    updatePassword(updatePasswordDto: UpdatePasswordDto): Promise<{
        message: any;
    }>;
}
