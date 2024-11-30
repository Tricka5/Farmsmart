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
        password: string;
        userid: number;
        firstname: string;
        lastname: string;
        profilepicture: string;
        email: string;
        activationstatus: boolean;
    }[]>;
    getCurrentInbox(params: any): Promise<{
        inboxid: number;
    }>;
}
