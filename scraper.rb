require 'mechanize'
require 'yaml'

def run!
  all = teams.map do |team|
    { teams:
      { team: team, players: roster }
    }
  end

  f = File.new("rosters.yml", "a")
  f.write(all.to_yaml)
  f.close
end

def agent
  Mechanize.new
end

def page
  @page ||= agent.get "http://www.mlssoccer.com/worldcup/2014/news/article/2014/05/15/world-cup-did-you-miss-out-all-roster-unveilings-mlssoccercom-gets-you-date?gclid=CLWX_4P1zr4CFaFDMgod9lgA7w"
end

def roster
  all_players = []
  roster_links = page.links_with(text: /ROSTER/).map(&:href)
  roster_links.each do |roster|
    players = agent.get(roster_links[31]).links_with(href: /players\//).map(&:href)
    players.each do |player|
      subject = agent.get(player)
      position = subject.search('.player-position').text.strip
      name = subject.search('.player-name').text.strip
      info = subject.search('.player-info ul').children.map do |profile_info|
        profile_info.text.slice(/\n.*$/).strip
      end
      current_club = subject.search('.block_body .content p:first').text.slice(/:.*$/)[2..-1]
      all_players.push({
        position: position,
        name: name,
        height: info[2],
        weight: info[4],
        birthdate: info[6],
        birthplace: info[8],
        current_club: current_club
      })
    end
  end
  all_players
end

def teams
  teams_list = page.links_with(text: /TEAM GUIDE/)
  teams_list.map { |link| link.href.slice(/4\/.*/)[2..-1] }
end

run!
