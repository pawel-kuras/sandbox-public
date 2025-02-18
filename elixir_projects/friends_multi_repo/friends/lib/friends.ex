defmodule Friends do
  # query the database for all people
  def get_people do
    Friends.FriendsRepo.all(Friends.Person)
  end
end
