module ProfilesHelper
  def authorization_details_for(authorization)
    out="<div class='#{authorization.provider} inlined'></div>"
    begin
    if authorization.provider.eql?("twitter")
      client = Twitter::Client.new
      twitter_username = client.user(authorization.uid.to_i).screen_name
      out += "<span>#{ link_to(twitter_username, "http://www.twitter.com/"+twitter_username, :target => "_blank")}</span>"
    end
    if authorization.provider.eql?("facebook")
      client = FbGraph::User.me authorization.token
      user_data=client.fetch
      out += "<span>#{ link_to(user_data.name, "#{user_data.link}", :target => "_blank")}</span>"
    end
    rescue
    end
    "#{out}</br>".html_safe
    
  end
end