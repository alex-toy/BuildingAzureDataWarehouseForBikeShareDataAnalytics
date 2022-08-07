# Building an Azure Data Warehouse for Bike Share Data Analytics

Divvy is a bike sharing program in Chicago, Illinois USA that allows riders to purchase a pass at a kiosk or use a mobile application to unlock a bike at stations around the city and use the bike for a specified amount of time. The bikes can be returned to the same station or to another station. The City of Chicago makes the anonymized bike trip data publicly available for projects like this where we can analyze the data. The dataset looks like this:

<img src="/pictures/data-model.png" title="data model"  width="600">

The goal of this project is to develop a data warehouse solution using Azure Synapse Analytics. We will:

- Design a star schema based on the business outcomes listed below;
- Import the data into Synapse;
- Transform the data into the star schema;
- and finally, view the reports from Analytics.

The business outcomes we are designing for are as follows:
1. Analyze how much time is spent per ride
- Based on date and time factors such as day of week and time of day
- Based on which station is the starting and / or ending station
- Based on age of the rider at time of the ride
- Based on whether the rider is a member or a casual rider
2. Analyze how much money is spent
- Per month, quarter, year
- Per member, based on the age of the rider at account start
3. EXTRA CREDIT - Analyze how much money is spent per member
- Based on how many rides the rider averages per month
- Based on how many minutes the rider spends on a bike per month



# Steps To Reproduce The project

## Task1 : Creating resources

1. Create an **Azure Synapse Workspace**
<img src="/pictures/synapse-workspace.png" title="synapse workspace"  width="700">

2. Create an **Azure SQL database**. Choose *SQL Authentication*. Don't forget to configure your database as **Basic**, to save money.
<img src="/pictures/sql.png" title="sql database"  width="700">

3. Create an **Azure Storage Account**
<img src="/pictures/storage-account.png" title="storage account"  width="700">

4. Create an **Azure PostgreSQL Database** (use Flexible Server, workload type development, add a firewall rule to allow access from any azure service)
<img src="/pictures/postgres.png" title="postgres"  width="700">

Then run **python DataToPostgres.py** in order to populate the PostgreSQL database. You will then be able to see the data later on, when we create a **Linked Service**.

5. Create a **Dedicated SQL pools**. Choose *SQL Authentication* when creating the server. Don't forget to set the performance level, which is the basis for the cost.
Warning : that resource needs not be created here, but later on in the *data/SQL pool* section of the workspace.
<img src="/pictures/sql-pool.png" title="dedicated sql pool"  width="700">



## Ingesting data into Azure Synapse

1. Go to the **Linked Services** section
<img src="/pictures/linked-services.png" title="linked services"  width="700">

2. Create an **Azure Database for PostgreSQL** linked service. For **Encryption**, choose **Request SSL**.
<img src="/pictures/linked-service-postgres.png" title="linked services postgres"  width="300">

3. Create an **Azure Blob storage** linked service
<img src="/pictures/linked-service-blob.png" title="linked services blob storage"  width="300">

4. in order to create a **Linked Service** Go to the **Home/Ingest** section and select **Built-in copy task** and **Run once now**.
<img src="/pictures/home-ingest.png" title="ingest"  width="700">

5. Then select **Azure Database for PostgreSQL** as a source and choose the *accident* table.
<img src="/pictures/postgres-source.png" title="postgres source"  width="700">

6. Then add a destination link to **Azure Blob Storage** as a source
<img src="/pictures/link-destination.png" title="link destination"  width="700">

In the data section, you will find your newly created link :
<img src="/pictures/newly-created-link.png" title="newly created link"  width="700">



## Create Staging Tables

Upload us-accidents.csv to Data/Azure DataLake Storage Gen2 ??????

1. Create external table
<img src="/pictures/create-external-table.png" title="create external table"  width="700">

2. Then run the script to create a **staging table**. You should first give meaning names to the columns. Note that DATETIME type is not well understood by Azure and you should turn them to VARCHAR(20).
<img src="/pictures/external-table-script.png" title="external table script"  width="700">

3. You should now see an external table created in the *Data/Workspace* section :
<img src="/pictures/newly-created-table.png" title="newly created table"  width="300">

3. You should now be able to run any query on the newly created table :
<img src="/pictures/external-table-query.png" title="external table query"  width="700">




## Create Tables

1. Go to the Develop section and create a script
<img src="/pictures/create-table.png" title="create table"  width="700">

1. Run script create_tables.sql
<img src="/pictures/create-table-script.png" title="create table script"  width="700">