import { insertInbox } from 'src/db/schema';
export declare class InboxService {
    createEntry(data: insertInbox): Promise<{
        inboxid: number;
        lastmessage: string;
    }>;
}
