--Get the average number of seconds between events in the first 5 minutes of gameplay.
WITH first_day_events AS
  (SELECT userId,
          gaUserStartDate,
          eventName,
          msSinceLastEvent,
          min(eventTimestamp) over (partition BY userId
                                    ORDER BY eventId) AS startTimeStamp,
          eventTimestamp
   FROM EVENTS
   WHERE eventDate = gaUserStartDate
     AND sessionID IS NOT NULL),
     firstMinutes AS
  (SELECT userId,
          gaUserStartDate,
          msSinceLastEvent
   FROM first_day_events
   WHERE eventTimestamp - startTimeStamp<=interval '5 minute'-- check first 5 minutes
)
SELECT gaUserStartDate AS 'Date',
       avg(msSinceLastEvent/1000)AS 'Average number of seconds between events'
FROM firstMinutes
GROUP BY 1
ORDER BY 1 DESC
