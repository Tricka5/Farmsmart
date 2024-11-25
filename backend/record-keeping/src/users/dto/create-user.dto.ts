import { IsInt } from 'class-validator';

export class CreateUserDto {
    @IsInt()
    first_userid: number;

    @IsInt()
    second_userid: number;
}
