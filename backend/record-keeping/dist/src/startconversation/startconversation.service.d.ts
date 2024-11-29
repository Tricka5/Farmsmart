import { CreateStartconversationDto } from './dto/create-startconversation.dto';
import { UpdateStartconversationDto } from './dto/update-startconversation.dto';
export declare class StartconversationService {
    create(createStartconversationDto: CreateStartconversationDto): string;
    findAll(): string;
    findOne(id: number): string;
    update(id: number, updateStartconversationDto: UpdateStartconversationDto): string;
    remove(id: number): string;
}
