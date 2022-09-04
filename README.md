# Building an Azure Data Warehouse for Bike Share Data Analytics

Divvy is a bike sharing program in Chicago, Illinois USA that allows riders to purchase a pass at a kiosk or use a mobile application to unlock a bike at stations around the city and use the bike for a specified amount of time. The bikes can be returned to the same station or to another station. The City of Chicago makes the anonymized bike trip data publicly available for projects like this where we can analyze the data. The dataset looks like this:

<img src="/pictures/data-model.png" title="data model"  width="400">

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
3. Analyze how much money is spent per member
- Based on how many rides the rider averages per month
- Based on how many minutes the rider spends on a bike per month



# Steps To Reproduce The project

## Task1 : Creating resources

1. Create an **Azure Synapse Workspace**
<img src="/pictures/synapse-workspace1.png" title="synapse workspace"  width="500">
<img src="/pictures/synapse-workspace2.png" title="synapse workspace"  width="500">

2. Create a **Dedicated SQL pools** inside the **Synapse Workspace**.

Warning : that resource needs to be created *data/SQL pool* section of the workspace.
<img src="/pictures/sql-pool-section.png" title="dedicated sql pool"  width="700">

Choose *SQL Authentication* when creating the server. Don't forget to set the performance level, which is the basis for the cost.

<img src="/pictures/sql-pool.png" title="dedicated sql pool"  width="700">

3. Create an **Azure Storage Account**
<img src="/pictures/storage-account.png" title="storage account"  width="700">



## Task 2: Design a star schema

Here is the star model that I have designed to answer the business questions :
<img src="/pictures/star_model.png" title="star model"  width="700">



## Task 3: Create the data in PostgreSQL

To prepare our environment for this project, we first must create the data in PostgreSQL. This will simulate the production environment where the data is being used in the OLTP system. 
Create an **Azure PostgreSQL Database** (use Flexible Server, workload type development, add a firewall rule to allow access from any azure service)
<img src="/pictures/postgres1.png" title="postgres"  width="700">
<img src="/pictures/postgres2.png" title="postgres"  width="700">

Then run **python DataToPostgres.py** in order to populate the PostgreSQL database. You will then be able to see the data later on, when we create a **Linked Service**.



## Task 4: EXTRACT the data from PostgreSQL

In your Azure Synapse workspace, we will use the ingest wizard to create a one-time pipeline that ingests the data from PostgreSQL into Azure Blob Storage. This will result in all four tables being represented as text files in Blob Storage, ready for loading into the data warehouse.

1. Go to the **Linked Services** section
<img src="/pictures/linked-services.png" title="linked services"  width="700">

2. Create an **Azure Database for PostgreSQL** linked service. For **Encryption**, choose **Request SSL**.
<img src="/pictures/linked-service-postgres.png" title="linked services postgres"  width="300">
<img src="/pictures/linked-service-postgres-config.png" title="linked services postgres config"  width="300">

3. Create an **Azure Blob storage** linked service
<img src="/pictures/linked-service-blob.png" title="linked services blob storage"  width="300">
<img src="/pictures/linked-service-blob-config.png" title="linked services blob storage config"  width="300">

4. in order to ingest data into **Blob Storage**,  Go to the **Home/Ingest** section and select **Built-in copy task** and **Run once now**.
<img src="/pictures/home-ingest.png" title="ingest"  width="700">

5. Then select **Azure Database for PostgreSQL** as a source and choose all the relevant tables.
<img src="/pictures/postgres-source.png" title="postgres source"  width="700">

6. Then add a destination link to **Azure Blob Storage** as a source
<img src="/pictures/link-destination.png" title="link destination"  width="700">

In the data section, you will find your newly created link :
<img src="/pictures/newly-created-link.png" title="newly created link"  width="700">



## Task 5: LOAD the data into external tables in the data warehouse

Once in Blob storage, the files will be shown in the data lake node in the Synapse Workspace. From here, we can use the script generating function to load the data from blob storage into external staging tables in the data warehouse we created using the Dedicated SQL Pool.

Upload all data files to Data/Azure DataLake Storage Gen2 ??????

1. Create external table for all the staging tables.
<img src="/pictures/create-external-table.png" title="create external table"  width="700">
<img src="/pictures/create-external-table-config.png" title="create external table"  width="700">

2. Then run the script to create a **staging table** for all staging tables.
- You should first give meaning names to the columns. 
- Note that DATETIME type is not well understood by Azure and you should turn them to VARCHAR(50).
- make sure you are on **bikesharesqlpool** and not the **master** database.
<img src="/pictures/external-table-script.png" title="external table script"  width="700">

3. You should now see the external tables created in the *Data/Workspace* section :
<img src="/pictures/newly-created-table.png" title="newly created table"  width="300">

3. You should now be able to run any query on the newly created table :
<img src="/pictures/external-table-query.png" title="external table query"  width="700">



## Task 6: TRANSFORM the data to the star schema

We will write SQL scripts to transform the data from the staging tables to the final star schema we designed.

CAUTION : always make sure you are connected to the right database **bikesharesqlpool** !!

1. Go to the Develop section and create a script
<img src="/pictures/create-table.png" title="create table"  width="700">

2. Run all scripts in *starTables.sql* in order to create the star tables
<img src="/pictures/create-star-table-script.png" title="create table script"  width="700">

3. At the end of the process, you should see your star model tables created and populated in the 
<img src="/pictures/star_tables.png" title="star tables"  width="300">