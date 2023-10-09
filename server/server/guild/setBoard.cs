﻿using Anna.Request;
using common;
using System.Collections.Specialized;
using System.Web;

namespace server.guild
{
    internal class setBoard : RequestHandler
    {
        public override void HandleRequest(RequestContext context, NameValueCollection query)
        {
            var status = Database.Verify(query["guid"], query["password"], out DbAccount acc);
            if (status == LoginStatus.OK)
            {
                if (acc.GuildId <= 0 || acc.GuildRank < 20)
                {
                    Write(context, "<Error>No permission</Error>");
                    return;
                }

                var guild = Database.GetGuild(acc.GuildId);
                var text = HttpUtility.UrlDecode(query["board"]);
                if (Database.SetGuildBoard(guild, text))
                {
                    Write(context, text);
                    return;
                }

                Write(context, "<Error>Failed to set board</Error>");
            }
            else
                Write(context, "<Error>" + status.GetInfo() + "</Error>");
        }
    }
}