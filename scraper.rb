require 'mechanize'
require 'yaml'

def run!
  roster
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
    all_players = []
    @roster_page = agent.get roster
    player_links = @roster_page.search(".views-table.cols-6 a").map {|link| "http://www.mlssoccer.com/" + link.attributes['href'].value}

    player_links.each do |player|
      @subject = agent.get(player)
      position     = scrape_position
      name         = scrape_name.gsub(/\s+/, " ")
      info         = scrape_stats
      current_club = scrape_club
      p name

      all_players.push({
        position: position,
        name: name,
        height: info[3],
        weight: info[5],
        birthdate: info[7],
        birthplace: info[9],
        current_club: current_club
      })
    end

    f = File.new("rosters.yml", "a")
    f.write( { teams: { team: "Ivory Coast", players: all_players } }.to_yaml)
    f.close
  end

  all_players
end

def scrape_club
  @subject.search('.block_body .content p:first').text.slice(/:.*$/)[2..-1]
end

def scrape_stats
  @subject.search('.player-info ul').children.map do |profile_info|
    profile_info.text.slice(/\n.*$/).strip
  end
end

def scrape_name
  @subject.search('.player-name').text.strip
end

def scrape_position
  @subject.search('.player-position').text.strip
end


def roster_page(roster)
  @roster ||= agent.get(roster).links_with(href: /players\//).map(&:href)
end

# def roster_links
#   page.links_with(text: /ROSTER/).map(&:href)
# end

def teams
  teams_list = page.links_with(text: /TEAM GUIDE/)
  teams_list.map { |link| link.href.slice(/4\/.*/)[2..-1] }
end

def roster_links
  ["http://www.mlssoccer.com/worldcup/2014/ivory-coast/roster", "http://www.mlssoccer.com/worldcup/2014/cameroon/roster", "http://www.mlssoccer.com/worldcup/2014/ghana/roster"]
end

run!
