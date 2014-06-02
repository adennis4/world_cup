require 'yaml'

def rosters
  @rosters ||= YAML.load_file('data/rosters.yml')
end

def groups
  rosters[:groups]
end

def teams
  groups.map { |group| group[:teams] }.flatten
end

def players
  teams.map { |team| team[:players] }.flatten
end

def save_rosters
  File.open('rosters_with_locations.yml', 'w') do |file|
    file.write(rosters.to_yaml)
  end
end
