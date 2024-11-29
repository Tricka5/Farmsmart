export declare class EmailService {
    private transporter;
    constructor();
    generateOtp(): string;
    sendOtp(email: string, otp: string): Promise<void>;
}
