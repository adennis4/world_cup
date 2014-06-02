require 'yaml'

def rosters
  YAML.load_file('rosters.yml')
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
