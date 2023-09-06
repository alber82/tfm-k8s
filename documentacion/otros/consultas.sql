//Network


node_network_transmit_bytes_total


select * from node_network_transmit_bytes_total limit 10;

select time, value, series_id, val(device_id) device, val(instance_id) intance, val(job_id) job from node_network_transmit_bytes_total limit 10;

select distinct val(device_id) device from node_network_transmit_bytes_total;
select distinct val(instance_id) instance from node_network_transmit_bytes_total;



SELECT row_number() OVER() rowid,
       a.node,
       a.value
FROM   (
                SELECT   left(Val(instance_id),-5) node,
                         Max(value)                      value
                FROM     node_network_transmit_bytes_total
                WHERE    value <> 'Nan'
                AND      time >=Now()- interval '30 MINUTES'
                AND      time <=now()
                AND      val(device_id) IN ('eth1')
                GROUP BY val(instance_id)
                ORDER BY max(value) DESC) AS a;



SELECT row_number() OVER() rowid,
        a.node,
       a.value
FROM   (
           SELECT   left(Val(instance_id),-5) node,
               Last(value,time) - first(value,time) value
           FROM     node_network_transmit_bytes_total
           WHERE    value <> 'Nan'
             AND      time >=Now()- interval '15 MINUTES'
             AND      time <=now()
             AND      val(device_id) IN ('eth1')
           GROUP BY val(instance_id)
           ORDER BY Last(value,time) - first(value,time)  DESC) AS a;


SELECT  Val(instance_id) node,
    Last(value,time) - first(value,time) value
FROM     node_network_transmit_bytes_total
WHERE    time >=Now()- interval '5 MINUTES'
  AND      time <=now()
  AND      val(device_id) IN ('eth1')
GROUP BY val(instance_id)
ORDER BY Last(value,time) - first(value,time)  DESC

SELECT row_number() OVER() rowid,
        a.node,
       a.value
FROM   (
           SELECT   left(Val(instance_id),-5) node,
               Last(value,time) - first(value,time) value
           FROM     node_network_transmit_bytes_total
           WHERE    value <> 'Nan'
             AND      time >=Now()- interval '5 MINUTES'
             AND      time <=now()
             AND      val(device_id) IN ('eth1')
           GROUP BY val(instance_id)
           ORDER BY Last(value,time) - first(value,time)  DESC) AS a;
-------------------------------------------------------------------


node_cpu_seconds_total

select * from node_cpu_seconds_total limit 10;

select time,value, val(cpu_id) cpu, val(instance_id) instance, val(job_id) job, val(mode_id) mode from node_cpu_seconds_total limit 10;

select distinct val(mode_id) mode from node_cpu_seconds_total;


select distinct val(instance_id) instance, val(cpu_id) cpu from node_cpu_seconds_total;


    SELECT row_number() OVER() rowid,
            b.node,
           b.value
    FROM   (
               SELECT   left(a.node,-5) node,
                        Sum(a.value)          value
               FROM     (
                   SELECT   Val(instance_id)      node,
                   Last(Val(cpu_id),time)cpu,
                   Max(value)            value
                   FROM     node_cpu_seconds_total
                   WHERE    value <> 'Nan'
                   AND      time >=Now()- interval '1 MINUTE'
                   AND      time <=now()
                   AND      val(mode_id)='idle'
                   GROUP BY val(instance_id),
                   val(cpu_id)) a
               GROUP BY node
               ORDER BY sum(value) ASC) AS b;



SELECT row_number() OVER() rowid,
        b.node,
       b.value
FROM   (
           SELECT   left(a.node,-5) node,
               Sum(a.value)          value
           FROM     (
               SELECT   Val(instance_id)      node,
               val(cpu_id) cpu,
               Last(value,time) - first(value,time) value
               FROM     node_cpu_seconds_total
               WHERE    value <> 'Nan'
               AND      time >=Now()- interval '15 MINUTE'
               AND      time <=now()- interval '5 MINUTE'
               AND      val(mode_id)='idle'
               GROUP BY val(instance_id),
               val(cpu_id)) a
           GROUP BY node
           ORDER BY sum(value) ASC) AS b;





SELECT val (instance_id) instance,
       max (value)      AS value
FROM   node_network_transmit_bytes_total
WHERE  val(device_id) = 'eth1'
GROUP  BY val (instance_id);

SELECT val(instance_id) instance,
    max(value) AS value
FROM node_network_receive_bytes_total
WHERE val(device_id) = 'eth0'
GROUP BY val(instance_id)


SELECT time,
    value,
    val(device_id) AS device,
    val(instance_id) AS instance
FROM node_network_receive_bytes_total
WHERE val(device_id) = 'eth0'
ORDER BY time
LIMIT 10;


SELECT time,
    value,
    device_id,
    instance_id AS instance
FROM node_network_receive_bytes_total
WHERE device_id = 411
ORDER BY time
LIMIT 10;

SELECT row_number() OVER() rowid,
        b.node,
       b.value
FROM   (
           SELECT   left(a.node,-5) node,
               Sum(a.value)          value
           FROM     (
               SELECT   Val(instance_id)      node,
               val(cpu_id) cpu,
               Last(value,time) - first(value,time) value
               FROM     node_cpu_seconds_total
               WHERE    value <> 'Nan'
               AND      time >=Now()- interval '45 MINUTE'
               AND      time <=now()- interval '5 MINUTE'
               AND      val(mode_id)='idle'

               AND      left(Val(instance_id),-5) <> '192.168.59.253'
               AND      left(Val(instance_id),-5) <> '192.168.59.254'
               GROUP BY val(instance_id),
               val(cpu_id)) a
           GROUP BY node
           ORDER BY sum(value) ASC) AS b;

SELECT row_number() OVER() rowid,
        a.node,
       a.value
FROM   (
           SELECT   left(Val(instance_id),-5) node,
               Last(value,time) - first(value,time) value
           FROM     node_network_transmit_bytes_total
           WHERE    value <> 'Nan'
             AND      time >=Now()- interval '15 MINUTES'
             AND      time <=now()
             AND      val(device_id) IN ('eth1')
             AND      left(Val(instance_id),-5) <> '192.168.59.253'
             AND      left(Val(instance_id),-5) <> '192.168.59.254'
           GROUP BY val(instance_id)
           ORDER BY Last(value,time) - first(value,time)  DESC) AS a;

SELECT   left(a.node,-5) node,
    Sum(a.value)          value
FROM     (
    SELECT   Val(instance_id)      node,
    val(cpu_id) cpu,
    Last(value,time) - first(value,time) value
    FROM     node_cpu_seconds_total
    WHERE    value <> 'Nan'
    AND      time >=Now()- interval '15 MINUTE'
    AND      time <=now()- interval '5 MINUTE'
    AND      val(mode_id)='idle'
    AND      left(Val(instance_id),-5) <> '192.168.59.253'
    AND      left(Val(instance_id),-5) <> '192.168.59.254'
    GROUP BY val(instance_id),
    val(cpu_id)) a
GROUP BY node
ORDER BY sum(value) ASC