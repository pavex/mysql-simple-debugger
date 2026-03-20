# MySQL Simple Debugger 🛠️

A lightweight and efficient debugging utility for MySQL and MariaDB stored procedures. This script allows you to log messages and variable values into a temporary in-memory table, making it easier to track execution flow where standard `SELECT` statements are impractical.

## 🚀 Key Features
* **In-Memory Storage:** Uses `ENGINE = MEMORY` for high-speed logging without disk overhead.
* **Safe Execution:** Each procedure checks for table existence to prevent runtime errors.
* **Clean & Simple:** A single SQL file provides a complete logging environment.

## 📦 Installation
1. Download the `debug_procedures.sql` file.
2. Import it into your database:
   ```sql
   SOURCE path/to/debug_procedures.sql;
   ```
   *(Or simply copy and execute the script content in your preferred SQL client like DBeaver, HeidiSQL, or MySQL Workbench).*

## 📖 Usage

The toolkit consists of four primary procedures:

### 1. Enable Debugging
Create the temporary debug table before starting your process:
```sql
CALL debug__enable();
```

### 2. Log Messages
Insert a simple text-based checkpoint into your code:
```sql
CALL debug__msg('Starting loop iteration');
```

### 3. Track Variables
Log a variable name along with its current value:
```sql
SET @current_user_id = 101;
CALL debug__var('UserID', @current_user_id);
```

### 4. Show & Cleanup
Retrieve all logged data. **Note:** This procedure displays the results and then automatically drops the debug table to clean up.
```sql
CALL debug__show();
```

## 🛠️ Practical Example

```sql
DELIMITER //
CREATE PROCEDURE MyComplexLogic()
BEGIN
    -- Initialize the logger
    CALL debug__enable();
    
    CALL debug__msg('Procedure execution started');
    
    -- Your business logic
    SET @total_count = (SELECT COUNT(*) FROM orders);
    CALL debug__var('OrderCount', @total_count);
    
    -- More logic...
    CALL debug__msg('Logic finished successfully');
    
    -- Display results and cleanup
    CALL debug__show();
END //
DELIMITER ;
```

## 📝 License
This project is open-source and free to use. 
