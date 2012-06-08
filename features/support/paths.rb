module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /^the index page$/
      '/'
    when /^the poll admin page$/
      poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key)
    when /^my ballot page$/
      vote_on_ballot_path(:poll_id => @ballot.poll.id, :ballot_key => @ballot.key)
    when /^the poll results$/
      poll_results_path(:poll_id => @ballot.poll.id, :ballot_key => @ballot.key)

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
