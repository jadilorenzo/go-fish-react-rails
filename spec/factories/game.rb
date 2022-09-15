FactoryBot.define do
  factory :game do
    name { 'Game 1' }
    player_count { '2' }
    users { [] }
    
    trait :two_players do
      users { [create(:user, :player1)]}
    end
  end
end
