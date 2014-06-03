module CustomHelpers
  def teams_list
    data.rosters.groups.map do |group|
      group.teams.map do |team|
        team['name']
      end
    end.flatten
  end
end
