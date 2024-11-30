import { MessageService } from './message.service';
import { insertMessages, selectMessages } from 'src/db/schema';
export declare class MessageController {
    private readonly messageService;
    constructor(messageService: MessageService);
    createMessage(CreateMessageDto: insertMessages): Promise<{
        inboxid: number;
        userid: number;
        message: string;
        createdat: Date;
    }>;
    catch(error: any): void;
    getMessagesByInboxId(id: number): Promise<selectMessages[]>;
}
