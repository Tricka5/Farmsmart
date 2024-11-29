import { insertMessages, selectMessages } from 'src/db/schema';
export declare class MessageService {
    addMessage(data: insertMessages): Promise<{
        userid: number;
        inboxid: number;
        message: string;
        createdat: Date;
    }>;
    catch(error: any): void;
    getMessagesByInboxId(id: number): Promise<selectMessages[] | null>;
}
