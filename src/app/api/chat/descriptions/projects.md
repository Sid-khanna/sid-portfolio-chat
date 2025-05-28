# My Projects

Here are some key projects I've undertaken. These demonstrate Siddharth Khanna's diverse skills and expertise across various domains, from robotics to AI and software development.

## ParSight (My Capstone Project)
**Description:** As part of our final-year engineering capstone, we developed **ParSight**, an autonomous drone system designed to assist senior golfers by tracking golf balls in real time and hovering over their final position to provide a clear visual reference. The project addressed a growing accessibility challenge in recreational sports—namely, age-related vision decline—by offering a real-time robotic solution that enhances visibility without interfering with gameplay. ParSight follows a **Sense–Plan–Act architecture**. Its sensing module features a downward-facing RGB camera mounted on a quadrotor drone, capturing video at 30 FPS. Frames are processed onboard via an **NVIDIA Jetson Nano** running **ROS2**. Real-time detection is achieved using **HSV color filtering** and **OpenCV-based contour detection**. The system scores contours based on size and circularity to isolate the red golf ball even in noisy or cluttered environments. Tracking is managed using **Image-Based Visual Servoing (IBVS)**, where the pixel offset between the ball and the image center is converted into a physical setpoint via a **Proportional-Derivative (PD) controller**. These setpoints are published to the drone’s flight controller, which adjusts motor output to maintain visual lock and ultimately hover over the ball’s final location. This project heavily utilized my skills in **robotics**, **computer vision**, **real-time perception**, **sensor fusion**, and **embedded systems development**.
**Technologies Used:** ROS2, OpenCV, NVIDIA Jetson Nano, Minion Mini H-Quad drone, Orange Cube+ flight controller, YOLOv11, TensorRT
**Skills Applied:** Robotics, Computer Vision, Real-time Perception, Sensor Fusion, Embedded Systems, PID Control, Image-Based Visual Servoing (IBVS), Autonomy, Problem-solving, System Integration
**Achievements/Metrics:**
* Achieved **95% detection accuracy** with a false-positive rate under 3%.
* Real-time inference at **30 Hz**.
* Total system latency of approximately **350 ms**.
* Successfully hovered within **6 cm** of the ball’s final resting position.
* Met **8 of 10** key performance benchmarks.
**Role:** Capstone Team Lead / Lead Developer
**Future Plans:** Higher-frame-rate cameras, upgraded compute platforms (e.g., Jetson Orin), YOLOv11-based deep learning models deployed with TensorRT for more robust outdoor tracking.

## AI Story Generator
**Description:** As someone who loves writing—and is currently in the process of self-publishing a novel on Amazon—storytelling has always been one of my most meaningful creative outlets. At the same time, as an engineering student, I’ve been immersed in designing structured, logic-driven systems. This project became the perfect intersection of those two worlds. The **AI Story Generator** is a web-based tool that guides users through a multi-step form to define a character’s voice, traits, tone, and genre. It then uses **OpenRouter’s LLM API** (such as **DeepSeek** or **Mistral**) to generate a rich, tailored character profile alongside a unique story blurb. Whether the genre is fantasy, sci-fi, or mystery, the tool adapts to user input to create engaging, genre-appropriate results. This project showcases my abilities in **web development**, **API integration**, **prompt engineering**, and applying **natural language processing (NLP)** concepts for creative applications.
**Technologies Used:** Flask, Tailwind CSS, OpenRouter (LLM API), DeepSeek, Mistral
**Skills Applied:** Web Development, API Integration, Prompt Engineering, Natural Language Processing (NLP), UI/UX Design, Creative Writing, Problem-solving, Full-stack Development
**Features:** Responsive UI, structured prompt logic, clean dialogue-styled prose output.
**Role:** Solo Developer
**Personal Connection:** Merges passion for writing with engineering skills. Highlights belief that engineering and creativity are complementary.
**Future Plans:** Expand platform with visual generation tools and longer-form story modes.

## ViT + LLM Recipe Generator (ingrAIdients)
**Description:** **ingrAIdients** is a completed deep learning project that reimagines how we interact with food using AI. The system allows users to upload a photo of a prepared dish and receive a breakdown of its ingredients, along with a fully generated recipe. Designed to support dietary tracking, allergen awareness, and creative meal recreation, it combines visual understanding with natural language generation to deliver a seamless user experience. This project demonstrates my expertise in **deep learning**, **computer vision**, **natural language processing (NLP)**, and **full-stack AI application development**.
**Datasets Used:** Recipe1M+, Food Ingredients and Recipe Dataset, Custom web-scraped dataset.
**Deep Learning Architecture:**
* **Convolutional Neural Networks (CNNs):** Initial trials with **ResNet-50** and **VGG-16** established baseline visual features. While effective at extracting core image embeddings, they struggled to generalize across visually complex dishes.
* **Recurrent Neural Networks (RNNs):** For ingredient list modeling, we used **GRUs** and **bi-directional LSTMs**, enabling multi-label predictions from CNN-generated feature vectors and supporting early ingredient detection.
* **Vision Transformers (ViT):** We adopted **ViT-B/16** as the final visual backbone. It significantly outperformed previous methods by capturing both spatial and contextual details in food images, yielding better ingredient predictions on diverse input types.
* **Large Language Model (LLM) Integration:** Used for generating complete recipes—including measurements, cooking steps, and variations—based solely on the predicted ingredient list. This turned ingrAIdients into a true end-to-end food intelligence pipeline.
* **Joint Embedding Space (Planned):** We also began exploring a joint embedding space between image features and ingredient text for future alignment improvements between visual and language models, though this has not been fully implemented.
**Skills Applied:** Deep Learning, Computer Vision, Natural Language Processing (NLP), Machine Learning, Model Training, Data Preprocessing, Dataset Creation, Model Evaluation, Problem-solving, AI Application Development
**Role:** Deep Learning Project Member
**Impact:** Demonstrates combining cutting-edge visual and language models to create intelligent, intuitive food applications. By blending curated and custom datasets with deep learning innovation, the project highlights how AI can make real-world impact in areas like health, nutrition, and culinary creativity.

## Formula 1 Predictor
**Description:** As a lifelong Formula 1 fan, I set out to build a personal machine learning project that predicts the outcomes of upcoming races. This project merges my passion for F1 with my interest in **data analysis** and **model optimization**, allowing me to explore how statistical trends can translate into competitive insights.
**Technologies Used:** Python, pandas, TensorFlow, Keras Tuner, BatchNormalization, Dropout
**Data:** Historical driver performance, team statistics, track history.
**Key Features:** Average qualifying position, constructor momentum, track-specific strengths, **recency bias decay function** (weights recent race results more heavily).
**Model Optimization:** **Hyperparameter optimization** with **Keras Tuner**, **regularization techniques** (BatchNormalization, Dropout), **callbacks** (EarlyStopping, ReduceLROnPlateau, custom loss threshold).
**Models Evaluated:** Linear Regression, Decision Trees, Extra Trees Ensemble, Neural Networks.
**Performance:** Neural networks and ensemble tree models achieved **R² scores exceeding 0.84**.
**Goal:** Provide **insight** into what’s driving the outcome—whether it’s a driver's form, track specialization, or team consistency. This project continuously challenges my skills in **data normalization**, **feature engineering**, and **real-world evaluation**.
**Skills Applied:** Machine Learning, Data Analysis, Model Optimization, Predictive Modeling, Python Programming, TensorFlow, Keras, Hyperparameter Optimization, Feature Engineering, Data Preprocessing, Statistical Analysis, Problem-solving
**Role:** Solo Developer

## Blue Sky Solar Racing (BSSR)
**Description:** As the **Chief Structural and Manufacturing Engineer** for the University of Toronto’s Blue Sky Solar Racing Team, I led the design and fabrication of the solar car body for the World Solar Challenge—a 3,000+ km race across the Australian Outback that pushes the limits of energy efficiency and engineering endurance. My role centered on optimizing the structural integrity and manufacturability of the car’s composite shell. I spearheaded the plug and mold fabrication process, focusing on reducing seamlines and streamlining layup workflows. Through iterative improvements in resin flow and mold construction, I helped **cut material waste by 17%**, accelerating production and improving surface quality. I oversaw the infusion of **carbon fiber** and **kevlar layups**, running tests to refine flow rates and curing conditions. I also managed our **3D printing operations**, optimizing print profiles to **reduce build times by 20%** while maintaining strength and precision. These components were used for aerodynamic add-ons and interior fitments. Throughout the project, I collaborated closely with the **electrical**, **solar array**, and **strategy** sub-teams to ensure mechanical decisions aligned with performance targets. From shell stiffness to mounting interfaces, every choice was made to balance durability, weight, and aerodynamic performance. This role tested my ability to deliver under tight deadlines and taught me how to **lead** in high-stakes environments. Beyond the technical achievements, it showed me the power of **hands-on collaboration**, **iterative design**, and **mission-driven teamwork**.
**Skills Applied:** Structural Engineering, Manufacturing Engineering, Composite Materials, 3D Printing, Project Management, Leadership, Teamwork, Problem-solving, Materials Science, Design Optimization, Quality Control, Interdisciplinary Collaboration
**Role:** Chief Structural and Manufacturing Engineer
**Team:** University of Toronto’s Blue Sky Solar Racing Team
**Achievements/Metrics:**
* Cut material waste by **17%**.
* Reduced 3D print build times by **20%**.
* Car completed the World Solar Challenge race.
**Lessons Learned:** Delivering under tight deadlines, leadership in high-stakes environments, hands-on collaboration, iterative design, mission-driven teamwork.

## Robotics for Space Exploration (RSX) Rover Team
**Description:** I was a core member of the **Robotics for Space Exploration (RSX)** Design Team, contributing to the development of planetary rovers for competitions such as the **Canadian International Rover Challenge (CIRC)** and the **University Rover Challenge (URC)**. My role focused on **autonomy** and **software**, where I gained hands-on experience with **sensor integration**, **real-time perception**, and **field-ready system deployment**. For **CIRC 2022**, I led the implementation of the rover’s **LiDAR** and **IMU** systems. This involved configuring hardware settings, writing **ROS nodes**, and synchronizing data streams to create a robust **perception pipeline**. The LiDAR proved instrumental during the science task, generating detailed topographical maps that improved our terrain classification and **boosted our science task performance by 20%**. I also contributed to the development of the rover’s **robotic arm**, writing and testing **Arduino code** for joint control and feedback loops. This required careful **calibration** and collaboration with the mechanical team to ensure safe actuation and precision handling during object manipulation challenges. In addition, I set up a dedicated **Ubuntu server** on one of our base laptops to run **ROS** and manage multi-process communication, giving the software team a stable environment for testing **autonomy algorithms**. I also explored forward-looking improvements for future competitions, researching **SLAM-based navigation** and **object detection modules**. This project taught me how to develop **real-time robotic systems** under field conditions—balancing performance with reliability while **debugging on the fly**. It deepened my understanding of **ROS**, **sensor fusion**, and **autonomous system design**, and gave me a strong appreciation for what it takes to make robots operate in the wild.
**Skills Applied:** Robotics, Autonomy, Software Development, Sensor Integration, Real-time Perception, Embedded Systems, ROS, LiDAR, IMU, Arduino, Ubuntu, SLAM, Object Detection, Debugging, System Integration, Teamwork, Problem-solving
**Role:** Core Member (Autonomy and Software focus)
**Team:** Robotics for Space Exploration (RSX) Design Team, University of Toronto
**Competitions:** Canadian International Rover Challenge (CIRC 2022), University Rover Challenge (URC)
**Achievements/Metrics:**
* LiDAR integration boosted science task performance by **20%** in CIRC 2022.
**Technologies Used:** ROS, ROS2, LiDAR, IMU, Arduino, Ubuntu
**Lessons Learned:** Developing real-time robotic systems under field conditions, balancing performance with reliability, debugging on the fly, sensor fusion, autonomous system design.

## EWB Curriculum Reform
**Description:** During my time with **Engineers Without Borders (EWB)**, I led the **Curriculum Change Project**—an initiative aimed at integrating **sustainability** more deeply into the **Engineering Strategies & Practice (ESP)** course at the University of Toronto. What began as a broad ambition became a focused, high-impact reform effort under my leadership. After taking over the project, I **rescaled the scope** to concentrate specifically on the ESP course, which touches nearly every first-year engineering student. I **recruited and mentored new team members**, conducted a **comparative analysis** of sustainability curricula at other institutions, and collaborated with the **Sustainability Engineering Association (SEA)** to launch a campus-wide survey. This survey captured valuable student perspectives on how sustainability should be represented in foundational engineering education. We synthesized our findings into a comprehensive **policy report** that outlined actionable strategies for integrating sustainability into course content, learning objectives, and project frameworks. I also engaged with course instructors and program leadership to review feasibility and implementation pathways, advocating for reforms that were both ambitious and pragmatic. Even after stepping down as team lead, I remained involved as a **consultant**, offering continuity and strategic guidance as the reforms moved toward adoption. The project significantly enhanced my abilities in **policy writing**, **stakeholder negotiation**, and **collaborative problem-solving** across institutional structures.
**Skills Applied:** Project Management, Leadership, Policy Writing, Stakeholder Negotiation, Collaborative Problem-solving, Research, Data Analysis (Survey data), Mentorship, Communication, Strategic Planning, Change Management
**Role:** Project Lead (Curriculum Change Project)
**Organization:** Engineers Without Borders (EWB), University of Toronto Chapter
**Achievements/Metrics:**
* Initiated high-impact reform effort for ESP course.
* Successfully engaged stakeholders and gathered student perspectives.
* Developed actionable policy report.
**Lessons Learned:** Policy writing, stakeholder negotiation, collaborative problem-solving, translating vision into institutional change, equipping engineers with tools for social/environmental challenges.

## Thesis: Optimizing 3D Metal Printing Using Machine Learning
**Description:** My undergraduate thesis presents a comprehensive framework to improve the reliability and quality of **Laser Directed Energy Deposition (LDED)**—an advanced metal additive manufacturing process—by integrating **high-speed thermal imaging** with **predictive machine learning models**. LDED enables the fabrication and repair of complex, high-value metal components, but its precision is often limited by the dynamic and unstable behavior of the melt pool. To address this, I designed a **high-throughput experimental setup** that systematically varied over **360 combinations** of laser power, scan speed, and powder feed rate. Each print trial was monitored in real time using a **2000 fps infrared camera**, enabling the capture of thermal dynamics throughout the deposition process. From this data, I extracted both **dynamic features** (e.g., melt pool stability, morphology, sputter density) and **static features** (e.g., track height, volume, surface roughness). Melt pool stability—quantified via steady-state duration and the coefficient of variation—emerged as the most consistent real-time predictor of print quality. Conversely, morphology and sputter density, though visually distinctive, showed poor correlation with geometric output and were excluded from further modeling. Using these features, I trained and evaluated four **regression models** to predict key quality indicators: **Linear Regression**, **Decision Trees**, **Extra Trees Ensemble**, and **Neural Networks**. These models were tested against target outcomes such as melt track height, melt pool area, and a hybrid quality score combining stability and surface roughness. Neural networks and ensemble tree models achieved the highest performance, with **R² scores exceeding 0.84**, demonstrating that hybrid feature sets offer significant predictive advantage over using static or dynamic features alone. This thesis not only deepens our understanding of LDED physics but also lays the groundwork for **real-time quality monitoring** and **closed-loop control**. The integration of high-speed IR sensing and interpretable ML models moves us closer to adaptive, intelligent metal printing systems—offering significant impact in aerospace, biomedical, and industrial manufacturing. This project significantly advanced my skills in **machine learning**, **data science**, **experimental design**, **materials science**, **additive manufacturing**, and **technical writing**.
**Skills Applied:** Machine Learning, Data Science, Experimental Design, Materials Science, Additive Manufacturing, Technical Writing, Data Analysis, Regression Modeling, Neural Networks, Statistical Analysis, Problem-solving, Research & Development, Process Optimization
**Process Studied:** Laser Directed Energy Deposition (LDED) - advanced metal additive manufacturing.
**Experimental Setup:** High-throughput setup, systematically varied over 360 combinations of laser power, scan speed, and powder feed rate.
**Monitoring:** Real-time monitoring using a 2000 fps infrared camera.
**Features Extracted:** Dynamic (melt pool stability, morphology, sputter density), Static (track height, volume, surface roughness).
**Models Trained/Evaluated:** Linear Regression, Decision Trees, Extra Trees Ensemble, Neural Networks.
**Target Outcomes:** Melt track height, melt pool area, hybrid quality score.
**Performance:** Neural networks and ensemble tree models achieved R² scores exceeding 0.84.
**Key Findings:**
* Scan speed and feed rate more influential than laser power in determining print quality.
* Stable prints were most common at high-power, low-scan-speed settings.
* Melt pool stability consistently outperformed traditional post-process geometry as an early indicator of defects.
**Impact:** Deepens understanding of LDED physics, lays groundwork for real-time quality monitoring and closed-loop control.
**Role:** Undergraduate Thesis Researcher
