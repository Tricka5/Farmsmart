import { InboxparticipantsService } from './inboxparticipants.service';
import { selectInboxParticpants, selectUsers } from 'src/db/schema';
export declare class InboxparticipantsController {
    private readonly inboxparticipantsService;
    constructor(inboxparticipantsService: InboxparticipantsService);
    getUserById(inboxidparticipantid: string): Promise<{
        userid: number;
        inboxid: number;
    }>;
    getAllUsers(id: string): Promise<selectUsers[]>;
    getUsersWithSimilarInbox(id: string): Promise<selectInboxParticpants[]>;
    getCurrentInbox(params: any): Promise<{
        inboxid: number;
    }[]>;
}
