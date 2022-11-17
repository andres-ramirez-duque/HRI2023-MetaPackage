;; Features:
;; Steps through procedure and has an activity at each step
;; Anxiety tests can be added to procedure steps
;; likes type of activity can be used after activity
;; Sensing for engagement at each procedure step
;; Sensing if procedure is finished
;;
;; Stategy is only currently partly implemented:
;; Idle for a turn if lost engagement
;; Don't perform the same action twice
;; Strategy for multi-step procedures with variable length
;; 
;;


(define (domain ivplacementsensing)
  (:requirements :non-deterministic :negative-preconditions :equality :typing)
  (:types
    activity procstep activitytype level
  )
  (:predicates
    (procedurestep)
    (naustep)
    (anxteststep)
    (procstage ?p - procstep)
    (stepproc ?p1 ?p2 - procstep)
    (done ?a - activity)
    (activitycategory ?a - activity ?t - activitytype)
    (requiredcategory ?a - procstep ?b - activitytype)
    (likes ?t - activitytype)
    (anxietymitigating ?t - activitytype)
    
    (anxietytest ?p - procstep)
    (okanxiety ?p - procstep)
    
    (similar ?l1 ?l2 - level)
    (distractionstrength ?a - activity ?l - level)
    (desiredstrength ?p - procstep ?l - level)
  )
    (:functions (total-cost) - number)
  
  (:action doactivity1a
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (not (anxietytest ?p))
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?x)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 1)
    )
  )
  (:action doactivity2a
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (okanxiety ?p)
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?x)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 1)
    )
  )
    (:action doactivity1b
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x ?y - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (not (anxietytest ?p))
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?y)
      (similar ?x ?y)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 5)
    )
  )
  (:action doactivity2b
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x ?y - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (okanxiety ?p)
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?y)
      (similar ?x ?y)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 5)
    )
  )
    (:action doactivity1c
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x ?y - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (not (anxietytest ?p))
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?y)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 10)
    )
  )
  (:action doactivity2c
    :parameters (?a - activity ?t - activitytype ?p - procstep ?x ?y - level)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (requiredcategory ?p ?t)
      
      (okanxiety ?p)
      
      (distractionstrength ?a ?x)
      (desiredstrength ?p ?y)
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 10)
    )
  )

    (:action mitigationactivity
    :parameters (?a - activity ?t - activitytype ?p - procstep)
    :precondition 
    (and
      (procstage ?p)
      (naustep)
      (not (done ?a))
      (activitycategory ?a ?t)
      (anxietymitigating ?t)
      (anxietytest ?p) 
      (not (okanxiety ?p))
    )
    :effect
    (and
      (done ?a)
      (not (naustep))
      (procedurestep)
      (increase (total-cost) 10)
    )
  )

  (:action progressprocstep1
    :parameters (?p1 ?p2 - procstep)
    :precondition 
    (and
      (procedurestep)
      (stepproc ?p1 ?p2)
      (procstage ?p1)
      (anxietytest ?p2)
    )
    :effect
    (and
      (not (procstage ?p1))
      (procstage ?p2)
      (not (procedurestep))
      (anxteststep)
    )
  )
  
  (:action progressprocstep2
    :parameters (?p1 ?p2 - procstep)
    :precondition 
    (and
      (procedurestep)
      (stepproc ?p1 ?p2)
      (procstage ?p1)
      (not (anxietytest ?p2))
    )
    :effect
    (and
      (not (procstage ?p1))
      (procstage ?p2)
      (not (procedurestep))
      (naustep)
    )
  )

  (:action anxietytest
    :parameters (?p - procstep)
    :precondition 
    (and
      (anxteststep)
      (anxietytest ?p)
      (procstage ?p)
    )
    :effect
    (and
      (not (anxteststep))
      (naustep)
      (oneof (okanxiety ?p) (and ))
    )
  )
)
