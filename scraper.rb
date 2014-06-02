require 'mechanize'
require 'yaml'

attr_reader :subject

def run!
  add_team
end

def team_json
  teams.map do |team|
    { teams: { team: team, players: roster } }
  end
end

def add_team
  f = File.new("rosters.yml", "a")
  f.write(team_json.to_yaml)
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

  roster_links.each do |roster|
    @roster.each do |player|
      position     = scrape_position
      name         = scrape_name
      info         = scrape_stats
      current_club = scrape_club

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

def scrape_club
  subject.search('.block_body .content p:first').text.slice(/:.*$/)[2..-1]
end

def scrape_stats
  subject.search('.player-info ul').children.map do |profile_info|
    profile_info.text.slice(/\n.*$/).strip
  end
end

def scrape_name
  subject.search('.player-name').text.strip
end

def scrape_position
  subject.search('.player-position').text.strip
end

def subject_page(player)
  @subject ||= agent.get(player)
end

def roster_page(roster)
  @roster ||= agent.get(roster).links_with(href: /players\//).map(&:href)
end

def roster_list
  page.links_with(text: /ROSTER/).map(&:href)
end

def teams
  teams_list = page.links_with(text: /TEAM GUIDE/)
  teams_list.map { |link| link.href.slice(/4\/.*/)[2..-1] }
end

run!
