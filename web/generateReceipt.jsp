<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receipt</title>
    <style>
        .container {
            width: 50%;
            margin: auto;
            border: 1px solid #000;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            font-family: Arial, sans-serif;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header h2 {
            margin: 0;
        }
        .details, .items {
            width: 100%;
            margin-bottom: 20px;
        }
        .details td, .items td, .items th {
            padding: 8px;
            border: 1px solid #000;
        }
        .details {
            margin-bottom: 30px;
        }
        .items {
            border-collapse: collapse;
        }
        .items th {
            background-color: #f2f2f2;
        }
        .total {
            text-align: right;
            margin-top: 20px;
            font-size: 1.2em;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 0.9em;
        }
        .button {
            display: block;
            width: 30%;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            cursor: pointer;
        }
        .button.back {
            background-color: #007bff;
            margin-top: 10px;
            
        }
        @media print {
            .button {
                display: none;
            }
        }
    </style>
    <script>
        function printReceipt() {
            window.print();
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Bill Receipt</h2>
            <p>Star Tailor Shop</p>
            <p>7/106, Arrottuparai, Gudalur, Nilgiris</p>
            <p>Phone: 8597465023</p>
        </div>
        <table class="details">
            <tr>
                <td><strong>Customer Name:</strong></td>
                <td><%= request.getParameter("customerName") %></td>
            </tr>
            <tr>
                <td><strong>Product Name:</strong></td>
                <td><%= request.getParameter("productName") %></td>
            </tr>
            <tr>
                <td><strong>Material Type:</strong></td>
                <td><%= request.getParameter("materialType") %></td>
            </tr>
            <tr>
                <td><strong>Body Size:</strong></td>
                <td><%= request.getParameter("bodySize") %></td>
            </tr>
            <tr>
                <td><strong>Product Color:</strong></td>
                <td><%= request.getParameter("color") %></td>
            </tr>
            <tr>
                <td><strong>Quantity:</strong></td>
                <td><%= request.getParameter("productQuantity") %></td>
            </tr>
        </table>
        <table class="items">
            <tr>
                <th>Description</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Total Price</th>
            </tr>
            <tr>
                <td><%= request.getParameter("productName") %></td>
                <td><%= request.getParameter("productQuantity") %></td>
                <td><%= request.getParameter("totalPrice") %></td>
                <td><%= request.getParameter("totalPrice") %></td>
            </tr>
        </table>
        <div class="total">
            <strong>Total Amount: </strong> <%= request.getParameter("totalPrice") %>
        </div>
        <div class="footer">
            <p>Thank you for your business!</p>
            <p>Star Tailor Shop</p>
        </div>
        <button class="button" onclick="printReceipt()">Print</button>
        <a href="viewCustomerBooking.jsp" class="button back">Back to Bookings</a>
    </div>
</body>
</html>
