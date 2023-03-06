
CREATE OR REPLACE VIEW full_problems WITH (security_invoker) AS
  SELECT
    problems.*,
    users.full_name,
    users.initials || problems.id AS front_id,
    topics.topics,
    topics.topics_short,
    COALESCE(unresolved_count.count, 0) AS unresolved_count
  FROM
    problems
    LEFT JOIN users ON users.id = problems.author_id

    -- make the topic into a comma separated string
    LEFT JOIN (
      SELECT 
        problem_topics.problem_id, 
        string_agg(global_topics.topic, ', ') AS topics, 
        string_agg(global_topics.topic_short, ', ') AS topics_short
      FROM
        problem_topics
        JOIN global_topics ON problem_topics.topic_id = global_topics.id
      GROUP BY problem_topics.problem_id
    ) AS topics ON problems.id = topics.problem_id

    -- count unresolved problems
    LEFT JOIN (
      SELECT 
        testsolve_answers.problem_id,
        COUNT(*) AS count
      FROM testsolve_answers
      WHERE
        testsolve_answers.resolved IS FALSE AND
        (testsolve_answers.feedback = '') IS FALSE
      GROUP BY testsolve_answers.problem_id
    ) AS unresolved_count ON problems.id = unresolved_count.problem_id;
