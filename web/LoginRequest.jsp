<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <title>Four Eyes Collective - Login Request</title>
        <style>
            :root {
                --primary: #4a4a4a;
                --secondary: #7d7d7d;
                --accent: #616161;
                --light: #ffffff;
                --dark: #2d2d2d;
                --gray: #e0e0e0;
                --text-light: #757575;
                --text-dark: #424242;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-attachment: fixed;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                overflow: hidden;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0.05;
                pointer-events: none;
            }

            .main-content {
                width: 100%;
                max-width: 1200px;
                padding: 2rem;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: space-between;
            }


            .form-container {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 450px;
                padding: 3rem;
                position: relative;
                overflow: hidden;
            }

            .form-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(to bottom, var(--primary), var(--secondary));
            }

            .form-box h2 {
                font-size: 1.5rem;
                margin-bottom: 2.5rem;
                color: var(--primary);
                position: relative;
                text-align: center;
                font-weight: 600;
            }

            .button-group {
                display: flex;
                justify-content: space-between;
                margin-top: 2rem;
            }

            .btn {
                display: inline-block;
                padding: 12px 30px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
                text-align: center;
            }

            .btn.back-btn {
                background-color: var(--accent);
                color: var(--light);
                border: 2px solid var(--accent);
            }

            .btn.back-btn:hover {
                background-color: var(--secondary);
                border-color: var(--secondary);
            }

            .btn {
                background-color: var(--dark);
                color: var(--light);
                border: 2px solid var(--dark);
            }

            .btn:hover {
                background-color: var(--primary);
                border-color: var(--primary);
            }

            @keyframes zoomIn {
                from {
                    opacity: 0;
                    transform: scale(0.5);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            @keyframes flipInY {
                from {
                    transform: perspective(400px) rotateY(90deg);
                    opacity: 0;
                }
                to {
                    transform: perspective(400px) rotateY(0);
                    opacity: 1;
                }
            }

            @media (max-width: 768px) {
                .form-container {
                    padding: 2rem;
                }

                .button-group {
                    flex-direction: column;
                    gap: 1rem;
                }

                .btn {
                    width: 100%;
                }
            }


            .header {
                margin-bottom: 2rem;
                text-align: center;
            }

            .logo-space {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 50%;
                width: 180px;
                height: 180px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                margin: 0 auto;
                transition: transform 0.3s ease;
            }

            .logo-space:hover {
                transform: scale(1.05);
            }

        </style>
    </head>
    <body>
        <main class="main-content">

            <div class="header">
                <a href="#" class="logo-space">
                    <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 120px;">
                </a>
            </div>

            <div class="form-container">
                <div class="form-box">
                    <h2>Please login to add & view your shopping cart</h2>
                    <div class="button-group">
                        <a href="javascript:history.back()" class="btn back-btn">Back</a>
                        <a href="LoginRoleSelection.html" class="btn">Login</a>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>