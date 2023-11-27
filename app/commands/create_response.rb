# # typed: strict

module Commands
  class CreateResponse < Commands::Base
    extend T::Sig

    sig do
      params(input: ResponseInput)
        .returns(Response)
    end
    def call(input:)
      response = Response.create(
        value: input.response,
        correct: input.solution == input.response,
        problem: input.problem,
        player: input.player,
        started_at: input.started_at,
        completed_at: input.completed_at
      )

      Commands::CreateOrUpdatePlayerProblemAggregate.call(player: input.player, problem: input.problem)

      response
    end
  end
end
