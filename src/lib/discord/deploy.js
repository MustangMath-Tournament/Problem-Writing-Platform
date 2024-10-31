import { registerCommands } from './register-commands.js';
import { registerMetadata } from './register-metadata.js';

const isDevelopment = process.env.NODE_ENV === 'development';

(async () => {
    try {
        await registerCommands(isDevelopment);
        await registerMetadata();
        // Exit successfully after completion
        process.exit(0);
    } catch (error) {
        console.error('Error during Discord command deployment:', error);
        // Exit with error code if something went wrong
        process.exit(1); 
    }
})();