using DiscordWebhook;

namespace common
{
    public class DiscordLogging
    {
        private bool Enabled;
        private string[] HackerCache = new string[5];
        private int HC = 0;

        public DiscordLogging(bool enabled)
        {
            Enabled = enabled;
        }

        public void ModClientLog(string info)
        {
            HackerCache[HC] = info;
            HC++;
            if (HC >= 5)
            {
                LogToDiscord(WebHooks.ModdedClient, "Haxors Log", $"[{string.Join(",", HackerCache)}]");
                HackerCache = new string[5];
                HC = 0;
            }
        }

        public void LogToDiscord(Webhook hook, string name, string content)
        {
            if (!Enabled) return;

            hook.PostData(new WebhookObject()
            {
                username = name,
                content = content
            });
        }
    }

    public class WebHooks
    {
        public static Webhook Test = new Webhook("https://discordapp.com/api/webhooks/757942534881411163/EDVEkEktOPyoaiv9f9HjF4d8lXqsebS1a1ZAkDx3fle_e0FhHqDeOA73WEF5hBaG4cXZ");
        public static Webhook ModdedClient = new Webhook("https://discordapp.com/api/webhooks/735860289181843566/3hOquVOwhrq7F6ewwYVUA3shl4_P6D5gg5EFG0uEp44T0yN-54YBRQUSHGku4cWE4iQu");
        public static Webhook ModCommand = new Webhook("https://discordapp.com/api/webhooks/735860383327453275/isNaa_lkN44nZtK0B-fNSO331oGmFV_WaUT-7u_z8O0-vUn4TfUdQEy-hrjjGYgz7orT");
        public static Webhook GiveItem = new Webhook("https://discordapp.com/api/webhooks/735860435294617680/ktIV91ZoGeORDaU4V3vWOmRqyi-PGrDGOxMvhTIo-LBGaDcsAwwpMQ5TzmN5vrBq8QRh");
        public static Webhook Special = new Webhook("https://discordapp.com/api/webhooks/735860494518452225/jPWwJUcdTldT7Y_2hopmR1xy7gb5G5HPOoImkiKmvB3pEMk8OktrL5qVH8gpUp7soIBg");
        public static Webhook Trade = new Webhook("https://discordapp.com/api/webhooks/737462662211829894/TosqoHTpd8emS71nPmSVR08dc1iXgxIt_y2Cj1HZ2Qf3l9Y6kUBJmaG8ZRikOvs_Skxd");
    }
}