# 1. display total revenue for March 2012

SELECT DATE_FORMAT(billing.charged_datetime, '%M') AS month, SUM(billing.amount) AS revenue
FROM billing
WHERE MONTH(billing.charged_datetime) = 3
AND YEAR(billing.charged_datetime) = 2012;

# 2. display total revenue collected from client with id = 2

SELECT clients.client_id, SUM(billing.amount) AS revenue
FROM clients
JOIN billing ON clients.client_id = billing.client_id
WHERE clients.client_id = 2;

# 3. display all sites that client id = 10 owns

SELECT clients.client_id, sites.domain_name AS website
FROM clients
JOIN sites ON clients.client_id = sites.client_id
WHERE clients.client_id = 10;

# 4a. display total number of sites created per month per year for client id = 1.

SELECT clients.client_id, COUNT(sites.site_id) AS number_of_websites, MONTHNAME(sites.created_datetime) AS month_created, 
YEAR(sites.created_datetime) AS year_created
FROM clients
JOIN sites ON clients.client_id = sites.client_id
WHERE clients.client_id = 1
GROUP BY month_created, year_created
ORDER BY year_created ASC;

# 4b. display total number of sites created per month per year for client id = 20.

SELECT clients.client_id, COUNT(sites.site_id) AS number_of_websites, MONTHNAME(sites.created_datetime) AS month_created, 
YEAR(sites.created_datetime) AS year_created
FROM clients
JOIN sites ON clients.client_id = sites.client_id
WHERE clients.client_id = 20
GROUP BY month_created, year_created
ORDER BY year_created ASC;

# 5. display total number of leads generated for each of the sites between Jan 1, 2011 to Feb 15, 2011.

SELECT sites.domain_name, COUNT(leads.leads_id) AS number_of_leads, DATE_FORMAT(leads.registered_datetime, '%M %d %Y') AS date_generated
FROM sites
JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-02-15'
GROUP BY sites.site_id;

# 6. display client names and total number of leads generated for each client between Jan 1, 2011 and Dec 31, 2011.

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, COUNT(leads.leads_id) AS number_of_leads
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY CONCAT_WS(' ', clients.first_name, clients.last_name)
ORDER BY COUNT(leads.leads_id) DESC;

# 7. display client names and total number of leads generated for each client each month betweens months 1-6 of 2011.

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, COUNT(leads.leads_id) AS number_of_leads, 
MONTHNAME(leads.registered_datetime) AS month_generated
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-06-30'
GROUP BY leads.leads_id
ORDER BY leads.registered_datetime;

# 8a. display client names and total number of leads generated for each client's sites between Jan 1, 2011 - Dec 31, 2011. Order by client id.

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, COUNT(leads.leads_id) AS number_of_leads,  
sites.domain_name, DATE_FORMAT(leads.registered_datetime, '%M %d %Y') AS date_generated
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY sites.domain_name
ORDER BY clients.client_id;

# 8b. display all clients, site names, and total number of leads generated from each site for all time.

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, COUNT(leads.leads_id) AS number_of_leads,  
sites.domain_name
FROM clients
JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
GROUP BY clients.client_id, sites.domain_name
ORDER BY clients.client_id, leads.registered_datetime;

# 9. display total revenue collected from each client for each month of the year, ordered by client id.

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, SUM(billing.amount) AS revenue, 
MONTHNAME(billing.charged_datetime) AS month_charge, YEAR(billing.charged_datetime) AS year_charge
FROM clients
JOIN billing ON clients.client_id = billing.client_id
GROUP BY client_name, MONTH(billing.charged_datetime), YEAR(billing.charged_datetime)
ORDER BY clients.client_id;

# 10. display all sites that each client owns. Group results so that each row shows a new client. Add a new field called 'sites' that has all sites that the client owns. (HINT: use GROUP_CONCAT)

SELECT CONCAT_WS(' ', clients.first_name, clients.last_name) AS client_name, GROUP_CONCAT(sites.domain_name SEPARATOR ' / ') AS websites
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
GROUP BY client_name
ORDER BY clients.client_id;