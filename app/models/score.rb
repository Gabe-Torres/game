# typed: strict

class Score < T::Struct
  const :total_problems_solved, Integer
  const :total_problmes_solved_since_yesterday, Integer
  const :consecutive_days_played, Integer
end
