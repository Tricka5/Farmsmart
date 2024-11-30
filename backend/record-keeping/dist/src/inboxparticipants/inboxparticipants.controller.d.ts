import { InboxparticipantsService } from './inboxparticipants.service';
export declare class InboxparticipantsController {
    private readonly inboxparticipantsService;
    constructor(inboxparticipantsService: InboxparticipantsService);
    getUserById(inboxidparticipantid: string): Promise<{
        inboxid: number;
        firstuserid: number;
        seconduserid: number;
    }>;
    getFriends(currentuserid: number): Promise<{
        secondinboxid: number;
    }[]>;
    getAllUsers(id: string): Promise<{
        userid: number;
        firstname: string;
        lastname: string;
        profilepicture: string;
        email: string;
        password: string;
        activationstatus: boolean;
    }[]>;
    getCurrentInbox(params: any): Promise<{
        inboxid: number;
    }>;
}
