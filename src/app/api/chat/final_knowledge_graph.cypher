
CREATE CONSTRAINT FOR (p:Person) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT FOR (s:Skill) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT FOR (t:Technology) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT FOR (pr:Project) REQUIRE pr.id IS UNIQUE;
CREATE CONSTRAINT FOR (v:Value) REQUIRE v.id IS UNIQUE;
CREATE CONSTRAINT FOR (r:Role) REQUIRE r.id IS UNIQUE;
CREATE CONSTRAINT FOR (c:Company) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT FOR (e:Education) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT FOR (i:Interest) REQUIRE i.id IS UNIQUE;
CREATE CONSTRAINT FOR (l:Location) REQUIRE l.id IS UNIQUE;

MERGE (me:Person {id: "Siddharth Khanna"})

MERGE (edu_University_of_Toronto:Education {id: "University of Toronto"})
MERGE (me)-[:STUDIED_AT]->(edu_University_of_Toronto)
MERGE (edu_Engineering_Science:Education {id: "Engineering Science"})
MERGE (me)-[:STUDIED_AT]->(edu_Engineering_Science)
MERGE (edu_Robotics_and_Advanced_Manufacturing:Education {id: "Robotics and Advanced Manufacturing"})
MERGE (me)-[:STUDIED_AT]->(edu_Robotics_and_Advanced_Manufacturing)
MERGE (company_MM:Company {id: "Mold Masters"})
MERGE (role_AI:Role {id: "Automation Intern"})
MERGE (me)-[:WORKED_AT]->(company_MM)
MERGE (me)-[:HAS_ROLE]->(role_AI)
MERGE (company_MM)-[:EMPLOYS]->(role_AI)
MERGE (v_Continuous_Learning:Value {id: "Continuous Learning"})
MERGE (me)-[:HAS_VALUE]->(v_Continuous_Learning)
MERGE (v_Collaboration:Value {id: "Collaboration"})
MERGE (me)-[:HAS_VALUE]->(v_Collaboration)
MERGE (v_Mentorship:Value {id: "Mentorship"})
MERGE (me)-[:HAS_VALUE]->(v_Mentorship)
MERGE (v_Problem_Solving:Value {id: "Problem-Solving"})
MERGE (me)-[:HAS_VALUE]->(v_Problem_Solving)
MERGE (v_Adaptable:Value {id: "Adaptable"})
MERGE (me)-[:HAS_VALUE]->(v_Adaptable)
MERGE (v_Resilient:Value {id: "Resilient"})
MERGE (me)-[:HAS_VALUE]->(v_Resilient)
MERGE (v_Ethical_Considerations_in_Technology_Development:Value {id: "Ethical Considerations in Technology Development"})
MERGE (me)-[:HAS_VALUE]->(v_Ethical_Considerations_in_Technology_Development)
MERGE (v_Empowering_Others:Value {id: "Empowering Others"})
MERGE (me)-[:HAS_VALUE]->(v_Empowering_Others)
MERGE (v_Knowledge_Sharing:Value {id: "Knowledge Sharing"})
MERGE (me)-[:HAS_VALUE]->(v_Knowledge_Sharing)
MERGE (i_Hiker:Interest {id: "Hiker"})
MERGE (me)-[:INTERESTED_IN]->(i_Hiker)
MERGE (i_Nature_Enthusiast:Interest {id: "Nature Enthusiast"})
MERGE (me)-[:INTERESTED_IN]->(i_Nature_Enthusiast)
MERGE (i_Advanced_Scuba_Diver:Interest {id: "Advanced Scuba Diver"})
MERGE (me)-[:INTERESTED_IN]->(i_Advanced_Scuba_Diver)
MERGE (i_Formula_1_Racing:Interest {id: "Formula 1 Racing"})
MERGE (me)-[:INTERESTED_IN]->(i_Formula_1_Racing)
MERGE (i_Data_Analysis:Interest {id: "Data Analysis"})
MERGE (me)-[:INTERESTED_IN]->(i_Data_Analysis)
MERGE (i_Fantasy_Books:Interest {id: "Fantasy Books"})
MERGE (me)-[:INTERESTED_IN]->(i_Fantasy_Books)
MERGE (i_Short_Stories:Interest {id: "Short Stories"})
MERGE (me)-[:INTERESTED_IN]->(i_Short_Stories)
MERGE (i_Self_Publishing_a_Novel:Interest {id: "Self-Publishing a Novel"})
MERGE (me)-[:INTERESTED_IN]->(i_Self_Publishing_a_Novel)
MERGE (i_Open_Source_Projects:Interest {id: "Open-Source Projects"})
MERGE (me)-[:INTERESTED_IN]->(i_Open_Source_Projects)
MERGE (loc_Delhi_India:Location {id: "Delhi, India"})
MERGE (me)-[:LIVED_IN]->(loc_Delhi_India)
MERGE (loc_Southeast_Asia:Location {id: "Southeast Asia"})
MERGE (me)-[:LIVED_IN]->(loc_Southeast_Asia)
MERGE (loc_Malaysia:Location {id: "Malaysia"})
MERGE (me)-[:LIVED_IN]->(loc_Malaysia)
MERGE (s_Automation:Skill {id: "Automation"})
MERGE (me)-[:HAS_SKILL]->(s_Automation)
MERGE (me)-[:USES]->(s_Automation)
MERGE (s_Programming:Skill {id: "Programming"})
MERGE (me)-[:HAS_SKILL]->(s_Programming)
MERGE (me)-[:USES]->(s_Programming)
MERGE (s_Software_Development:Skill {id: "Software Development"})
MERGE (me)-[:HAS_SKILL]->(s_Software_Development)
MERGE (me)-[:USES]->(s_Software_Development)
MERGE (s_CAD:Skill {id: "CAD"})
MERGE (me)-[:HAS_SKILL]->(s_CAD)
MERGE (me)-[:USES]->(s_CAD)
MERGE (s_Data_Workflow_Optimization:Skill {id: "Data Workflow Optimization"})
MERGE (me)-[:HAS_SKILL]->(s_Data_Workflow_Optimization)
MERGE (me)-[:USES]->(s_Data_Workflow_Optimization)
MERGE (s_User_centric_Design:Skill {id: "User-centric Design"})
MERGE (me)-[:HAS_SKILL]->(s_User_centric_Design)
MERGE (me)-[:USES]->(s_User_centric_Design)
MERGE (me)-[:HAS_SKILL]->(s_SQL)
MERGE (s_Database_Management:Skill {id: "Database Management"})
MERGE (me)-[:HAS_SKILL]->(s_Database_Management)
MERGE (me)-[:USES]->(s_Database_Management)
MERGE (s_Data_Extraction:Skill {id: "Data Extraction"})
MERGE (me)-[:HAS_SKILL]->(s_Data_Extraction)
MERGE (me)-[:USES]->(s_Data_Extraction)
MERGE (s_Automated_Reporting:Skill {id: "Automated Reporting"})
MERGE (me)-[:HAS_SKILL]->(s_Automated_Reporting)
MERGE (me)-[:USES]->(s_Automated_Reporting)
MERGE (s_Data_driven_Decision_Making:Skill {id: "Data-driven Decision Making"})
MERGE (me)-[:HAS_SKILL]->(s_Data_driven_Decision_Making)
MERGE (me)-[:USES]->(s_Data_driven_Decision_Making)
MERGE (s_Process_Optimization:Skill {id: "Process Optimization"})
MERGE (me)-[:HAS_SKILL]->(s_Process_Optimization)
MERGE (me)-[:USES]->(s_Process_Optimization)
MERGE (s_Interdepartmental_Collaboration:Skill {id: "Interdepartmental Collaboration"})
MERGE (me)-[:HAS_SKILL]->(s_Interdepartmental_Collaboration)
MERGE (me)-[:USES]->(s_Interdepartmental_Collaboration)
MERGE (s_Communication:Skill {id: "Communication"})
MERGE (me)-[:HAS_SKILL]->(s_Communication)
MERGE (me)-[:USES]->(s_Communication)
MERGE (s_Stakeholder_Management:Skill {id: "Stakeholder Management"})
MERGE (me)-[:HAS_SKILL]->(s_Stakeholder_Management)
MERGE (me)-[:USES]->(s_Stakeholder_Management)
MERGE (s_Productivity_Improvement:Skill {id: "Productivity Improvement"})
MERGE (me)-[:HAS_SKILL]->(s_Productivity_Improvement)
MERGE (me)-[:USES]->(s_Productivity_Improvement)
MERGE (s_UI_UX_Design:Skill {id: "UI_UX Design"})
MERGE (me)-[:HAS_SKILL]->(s_UI_UX_Design)
MERGE (me)-[:USES]->(s_UI_UX_Design)
MERGE (s_Problem_solving:Skill {id: "Problem-solving"})
MERGE (me)-[:HAS_SKILL]->(s_Problem_solving)
MERGE (me)-[:USES]->(s_Problem_solving)
MERGE (s_Continuous_Improvement:Skill {id: "Continuous Improvement"})
MERGE (me)-[:HAS_SKILL]->(s_Continuous_Improvement)
MERGE (me)-[:USES]->(s_Continuous_Improvement)
MERGE (t_Python:Technology {id: "Python"})
MERGE (me)-[:USES]->(t_Python)
MERGE (t_VB_NET:Technology {id: "VB_NET"})
MERGE (me)-[:USES]->(t_VB_NET)
MERGE (t_Java:Technology {id: "Java"})
MERGE (me)-[:USES]->(t_Java)
MERGE (t_JavaScript:Technology {id: "JavaScript"})
MERGE (me)-[:USES]->(t_JavaScript)
MERGE (t_C_plus_plus:Technology {id: "C_plus_plus"})
MERGE (me)-[:USES]->(t_C_plus_plus)
MERGE (t_C:Technology {id: "C"})
MERGE (me)-[:USES]->(t_C)
MERGE (t_Arduino_C_C_plus_plus:Technology {id: "Arduino (C_C_plus_plus)"})
MERGE (me)-[:USES]->(t_Arduino_C_C_plus_plus)
MERGE (t_SQL:Technology {id: "SQL"})
MERGE (me)-[:USES]->(t_SQL)
MERGE (t_LangChain:Technology {id: "LangChain"})
MERGE (me)-[:USES]->(t_LangChain)
MERGE (t_TensorFlow:Technology {id: "TensorFlow"})
MERGE (me)-[:USES]->(t_TensorFlow)
MERGE (t_Keras:Technology {id: "Keras"})
MERGE (me)-[:USES]->(t_Keras)
MERGE (t_PyTorch:Technology {id: "PyTorch"})
MERGE (me)-[:USES]->(t_PyTorch)
MERGE (t_Scikit_learn:Technology {id: "Scikit-learn"})
MERGE (me)-[:USES]->(t_Scikit_learn)
MERGE (t_OpenCV:Technology {id: "OpenCV"})
MERGE (me)-[:USES]->(t_OpenCV)
MERGE (t_Flask:Technology {id: "Flask"})
MERGE (me)-[:USES]->(t_Flask)
MERGE (t_Django:Technology {id: "Django"})
MERGE (me)-[:USES]->(t_Django)
MERGE (t_Streamlit:Technology {id: "Streamlit"})
MERGE (me)-[:USES]->(t_Streamlit)
MERGE (t_React:Technology {id: "React"})
MERGE (me)-[:USES]->(t_React)
MERGE (t_Node_js:Technology {id: "Node_js"})
MERGE (me)-[:USES]->(t_Node_js)
MERGE (t_ROS:Technology {id: "ROS"})
MERGE (me)-[:USES]->(t_ROS)
MERGE (t_ROS2:Technology {id: "ROS2"})
MERGE (me)-[:USES]->(t_ROS2)
MERGE (t_pandas:Technology {id: "pandas"})
MERGE (me)-[:USES]->(t_pandas)
MERGE (t_NumPy:Technology {id: "NumPy"})
MERGE (me)-[:USES]->(t_NumPy)
MERGE (t_Tailwind_CSS:Technology {id: "Tailwind CSS"})
MERGE (me)-[:USES]->(t_Tailwind_CSS)
MERGE (t_Neo4j:Technology {id: "Neo4j"})
MERGE (me)-[:USES]->(t_Neo4j)
MERGE (t_PostgreSQL:Technology {id: "PostgreSQL"})
MERGE (me)-[:USES]->(t_PostgreSQL)
MERGE (t_MongoDB:Technology {id: "MongoDB"})
MERGE (me)-[:USES]->(t_MongoDB)
MERGE (t_GraphQL:Technology {id: "GraphQL"})
MERGE (me)-[:USES]->(t_GraphQL)
MERGE (t_Docker:Technology {id: "Docker"})
MERGE (me)-[:USES]->(t_Docker)
MERGE (t_Git:Technology {id: "Git"})
MERGE (me)-[:USES]->(t_Git)
MERGE (t_CI_CD:Technology {id: "CI_CD"})
MERGE (me)-[:USES]->(t_CI_CD)
MERGE (t_Linux:Technology {id: "Linux"})
MERGE (me)-[:USES]->(t_Linux)
MERGE (t_Ubuntu:Technology {id: "Ubuntu"})
MERGE (me)-[:USES]->(t_Ubuntu)
MERGE (p_ParSight:Project {id: "ParSight"})
MERGE (me)-[:DEMONSTRATES]->(p_ParSight)
MERGE (s_Robotics:Skill {id: "Robotics"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Robotics)
MERGE (s_Computer_Vision:Skill {id: "Computer Vision"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Computer_Vision)
MERGE (s_Real_time_Perception:Skill {id: "Real-time Perception"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Real_time_Perception)
MERGE (s_Sensor_Fusion:Skill {id: "Sensor Fusion"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Sensor_Fusion)
MERGE (s_Embedded_Systems:Skill {id: "Embedded Systems"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Embedded_Systems)
MERGE (s_PID_Control:Skill {id: "PID Control"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_PID_Control)
MERGE (s_Image_LIVED_Visual_Servoing_IBVS:Skill {id: "Image-LIVED Visual Servoing (IBVS)"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Image_LIVED_Visual_Servoing_IBVS)
MERGE (s_Autonomy:Skill {id: "Autonomy"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Autonomy)
MERGE (p_ParSight)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (s_System_Integration:Skill {id: "System Integration"})
MERGE (p_ParSight)-[:APPLIES_TO]->(s_System_Integration)
MERGE (p_ParSight)-[:USES]->(t_ROS2)
MERGE (p_ParSight)-[:USES]->(t_OpenCV)
MERGE (t_NVIDIA_Jetson_Nano:Technology {id: "NVIDIA Jetson Nano"})
MERGE (p_ParSight)-[:USES]->(t_NVIDIA_Jetson_Nano)
MERGE (t_HSV_color_filtering:Technology {id: "HSV color filtering"})
MERGE (p_ParSight)-[:USES]->(t_HSV_color_filtering)
MERGE (p_AI_Story_Generator:Project {id: "AI Story Generator"})
MERGE (me)-[:DEMONSTRATES]->(p_AI_Story_Generator)
MERGE (s_Web_Development:Skill {id: "Web Development"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Web_Development)
MERGE (s_API_Integration:Skill {id: "API Integration"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_API_Integration)
MERGE (s_Prompt_Engineering:Skill {id: "Prompt Engineering"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Prompt_Engineering)
MERGE (s_Natural_Language_Processing_NLP:Skill {id: "Natural Language Processing (NLP)"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Natural_Language_Processing_NLP)
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_UI_UX_Design)
MERGE (s_Creative_Writing:Skill {id: "Creative Writing"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Creative_Writing)
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (s_Full_stack_Development:Skill {id: "Full-stack Development"})
MERGE (p_AI_Story_Generator)-[:APPLIES_TO]->(s_Full_stack_Development)
MERGE (p_AI_Story_Generator)-[:USES]->(t_Flask)
MERGE (p_AI_Story_Generator)-[:USES]->(t_Tailwind_CSS)
MERGE (t_OpenRouter_LLM_API:Technology {id: "OpenRouter (LLM API)"})
MERGE (p_AI_Story_Generator)-[:USES]->(t_OpenRouter_LLM_API)
MERGE (t_DeepSeek:Technology {id: "DeepSeek"})
MERGE (p_AI_Story_Generator)-[:USES]->(t_DeepSeek)
MERGE (t_Mistral:Technology {id: "Mistral"})
MERGE (p_AI_Story_Generator)-[:USES]->(t_Mistral)


MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients:Project {id: "ViT + LLM Recipe Generator (ingrAIdients)"})
MERGE (me)-[:DEMONSTRATES]->(p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)
MERGE (s_Deep_Learning:Skill {id: "Deep Learning"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Deep_Learning)
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Computer_Vision)
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Natural_Language_Processing_NLP)
MERGE (s_Machine_Learning:Skill {id: "Machine Learning"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Machine_Learning)
MERGE (s_Model_Training:Skill {id: "Model Training"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Model_Training)
MERGE (s_Data_Preprocessing:Skill {id: "Data Preprocessing"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Data_Preprocessing)
MERGE (s_Dataset_Creation:Skill {id: "Dataset Creation"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Dataset_Creation)
MERGE (s_Model_Evaluation:Skill {id: "Model Evaluation"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Model_Evaluation)
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (s_AI_Application_Development:Skill {id: "AI Application Development"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:APPLIES_TO]->(s_AI_Application_Development)
MERGE (t_ResNet_50:Technology {id: "ResNet-50"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_ResNet_50)
MERGE (t_VGG_16:Technology {id: "VGG-16"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_VGG_16)
MERGE (t_GRUs:Technology {id: "GRUs"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_GRUs)
MERGE (t_Bi_directional_LSTMs:Technology {id: "Bi-directional LSTMs"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_Bi_directional_LSTMs)
MERGE (t_ViT_B_16:Technology {id: "ViT-B_16"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_ViT_B_16)
MERGE (t_Vision_Transformers_ViT:Technology {id: "Vision Transformers (ViT)"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_Vision_Transformers_ViT)
MERGE (t_Large_Language_Model_LLM_Integration:Technology {id: "Large Language Model (LLM) Integration"})
MERGE (p_ViT_plus_LLM_Recipe_Generator_ingrAIdients)-[:USES]->(t_Large_Language_Model_LLM_Integration)
MERGE (p_Formula_1_Predictor:Project {id: "Formula 1 Predictor"})
MERGE (me)-[:DEMONSTRATES]->(p_Formula_1_Predictor)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Machine_Learning)
MERGE (s_Data_Analysis:Skill {id: "Data Analysis"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Data_Analysis)
MERGE (s_Model_Optimization:Skill {id: "Model Optimization"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Model_Optimization)
MERGE (s_Predictive_Modeling:Skill {id: "Predictive Modeling"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Predictive_Modeling)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Python_Programming)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_TensorFlow)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Keras)
MERGE (s_Hyperparameter_Optimization:Skill {id: "Hyperparameter Optimization"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Hyperparameter_Optimization)
MERGE (s_Feature_Engineering:Skill {id: "Feature Engineering"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Feature_Engineering)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Data_Preprocessing)
MERGE (s_Statistical_Analysis:Skill {id: "Statistical Analysis"})
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Statistical_Analysis)
MERGE (p_Formula_1_Predictor)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (p_Formula_1_Predictor)-[:USES]->(t_TensorFlow)
MERGE (p_Formula_1_Predictor)-[:USES]->(t_Keras)


MERGE (t_Keras_Tuner:Technology {id: "Keras Tuner"})
MERGE (p_Formula_1_Predictor)-[:USES]->(t_Keras_Tuner)
MERGE (p_Blue_Sky_Solar_Racing_BSSR:Project {id: "Blue Sky Solar Racing (BSSR)"})
MERGE (me)-[:DEMONSTRATES]->(p_Blue_Sky_Solar_Racing_BSSR)
MERGE (s_Structural_Engineering:Skill {id: "Structural Engineering"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Structural_Engineering)
MERGE (s_Manufacturing_Engineering:Skill {id: "Manufacturing Engineering"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Manufacturing_Engineering)
MERGE (s_Composite_Materials:Skill {id: "Composite Materials"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Composite_Materials)
MERGE (s_3D_Printing:Skill {id: "3D Printing"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_3D_Printing)
MERGE (s_Project_Management:Skill {id: "Project Management"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Project_Management)
MERGE (s_Leadership:Skill {id: "Leadership"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Leadership)
MERGE (s_Teamwork:Skill {id: "Teamwork"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Teamwork)
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (s_Materials_Science:Skill {id: "Materials Science"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Materials_Science)
MERGE (s_Design_Optimization:Skill {id: "Design Optimization"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Design_Optimization)
MERGE (s_Quality_Control:Skill {id: "Quality Control"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Quality_Control)
MERGE (s_Interdisciplinary_Collaboration:Skill {id: "Interdisciplinary Collaboration"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:APPLIES_TO]->(s_Interdisciplinary_Collaboration)
MERGE (t_Carbon_Fiber:Technology {id: "Carbon Fiber"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:USES]->(t_Carbon_Fiber)
MERGE (t_Kevlar:Technology {id: "Kevlar"})
MERGE (p_Blue_Sky_Solar_Racing_BSSR)-[:USES]->(t_Kevlar)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team:Project {id: "Robotics for Space Exploration (RSX) Rover Team"})
MERGE (me)-[:DEMONSTRATES]->(p_Robotics_for_Space_Exploration_RSX_Rover_Team)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Robotics)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Autonomy)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Software_Development)
MERGE (s_Sensor_Integration:Skill {id: "Sensor Integration"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Sensor_Integration)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Real_time_Perception)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Embedded_Systems)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_ROS)
MERGE (s_LiDAR:Skill {id: "LiDAR"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_LiDAR)
MERGE (s_IMU:Skill {id: "IMU"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_IMU)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Arduino)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Ubuntu)
MERGE (s_SLAM:Skill {id: "SLAM"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_SLAM)
MERGE (s_Object_Detection:Skill {id: "Object Detection"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Object_Detection)
MERGE (s_Debugging:Skill {id: "Debugging"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Debugging)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_System_Integration)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Teamwork)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_ROS)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_ROS2)
MERGE (t_LiDAR:Technology {id: "LiDAR"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_LiDAR)
MERGE (t_IMU:Technology {id: "IMU"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_IMU)



MERGE (t_Arduino:Technology {id: "Arduino"})
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_Arduino)
MERGE (p_Robotics_for_Space_Exploration_RSX_Rover_Team)-[:USES]->(t_Ubuntu)
MERGE (p_EWB_Curriculum_Reform:Project {id: "EWB Curriculum Reform"})
MERGE (me)-[:DEMONSTRATES]->(p_EWB_Curriculum_Reform)
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Project_Management)
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Leadership)
MERGE (s_Policy_Writing:Skill {id: "Policy Writing"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Policy_Writing)
MERGE (s_Stakeholder_Negotiation:Skill {id: "Stakeholder Negotiation"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Stakeholder_Negotiation)
MERGE (s_Collaborative_Problem_solving:Skill {id: "Collaborative Problem-solving"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Collaborative_Problem_solving)
MERGE (s_Research:Skill {id: "Research"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Research)
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Data_Analysis)
MERGE (s_Mentorship:Skill {id: "Mentorship"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Mentorship)
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Communication)
MERGE (s_Strategic_Planning:Skill {id: "Strategic Planning"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Strategic_Planning)
MERGE (s_Change_Management:Skill {id: "Change Management"})
MERGE (p_EWB_Curriculum_Reform)-[:APPLIES_TO]->(s_Change_Management)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning:Project {id: "Thesis Optimizing 3D Metal Printing Using Machine Learning"})
MERGE (me)-[:DEMONSTRATES]->(p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Machine_Learning)
MERGE (s_Data_Science:Skill {id: "Data Science"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Data_Science)
MERGE (s_Experimental_Design:Skill {id: "Experimental Design"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Experimental_Design)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Materials_Science)
MERGE (s_Additive_Manufacturing:Skill {id: "Additive Manufacturing"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Additive_Manufacturing)
MERGE (s_Technical_Writing:Skill {id: "Technical Writing"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Technical_Writing)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Data_Analysis)
MERGE (s_Regression_Modeling:Skill {id: "Regression Modeling"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Regression_Modeling)
MERGE (s_Neural_Networks:Skill {id: "Neural Networks"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Neural_Networks)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Statistical_Analysis)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (s_Research_and_Development:Skill {id: "Research and Development"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Research_and_Development)
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:APPLIES_TO]->(s_Process_Optimization)
MERGE (t_Laser_Directed_Energy_Deposition_LDED:Technology {id: "Laser Directed Energy Deposition (LDED)"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:USES]->(t_Laser_Directed_Energy_Deposition_LDED)
MERGE (t_Infrared_Camera:Technology {id: "Infrared Camera"})
MERGE (p_Thesis_Optimizing_3D_Metal_Printing_Using_Machine_Learning)-[:USES]->(t_Infrared_Camera)
MERGE (s_CAD_Automation:Skill {id: "CAD Automation"})
MERGE (me)-[:HAS_SKILL]->(s_CAD_Automation)
MERGE (me)-[:USES]->(s_CAD_Automation)
MERGE (s_Script_Optimization:Skill {id: "Script Optimization"})
MERGE (me)-[:HAS_SKILL]->(s_Script_Optimization)
MERGE (me)-[:USES]->(s_Script_Optimization)
MERGE (s_3D_Model_Handling:Skill {id: "3D Model Handling"})
MERGE (me)-[:HAS_SKILL]->(s_3D_Model_Handling)
MERGE (me)-[:USES]->(s_3D_Model_Handling)


MERGE (s_Visual_Basic_NET:Skill {id: "Visual Basic NET"})
MERGE (me)-[:HAS_SKILL]->(s_Visual_Basic_NET)
MERGE (me)-[:USES]->(s_Visual_Basic_NET)
MERGE (s_Cross_functional_Collaboration:Skill {id: "Cross-functional Collaboration"})
MERGE (me)-[:HAS_SKILL]->(s_Cross_functional_Collaboration)
MERGE (me)-[:USES]->(s_Cross_functional_Collaboration)
MERGE (s_Workflow_Improvement:Skill {id: "Workflow Improvement"})
MERGE (me)-[:HAS_SKILL]->(s_Workflow_Improvement)
MERGE (me)-[:USES]->(s_Workflow_Improvement)
MERGE (s_Mechanical_Design:Skill {id: "Mechanical Design"})
MERGE (me)-[:HAS_SKILL]->(s_Mechanical_Design)
MERGE (me)-[:USES]->(s_Mechanical_Design)
MERGE (s_Lean_Manufacturing:Skill {id: "Lean Manufacturing"})
MERGE (me)-[:HAS_SKILL]->(s_Lean_Manufacturing)
MERGE (me)-[:USES]->(s_Lean_Manufacturing)
MERGE (s_Composite_Fabrication:Skill {id: "Composite Fabrication"})
MERGE (me)-[:HAS_SKILL]->(s_Composite_Fabrication)
MERGE (me)-[:USES]->(s_Composite_Fabrication)
MERGE (s_Mold_Making:Skill {id: "Mold Making"})
MERGE (me)-[:HAS_SKILL]->(s_Mold_Making)
MERGE (me)-[:USES]->(s_Mold_Making)
MERGE (s_Assembly:Skill {id: "Assembly"})
MERGE (me)-[:HAS_SKILL]->(s_Assembly)
MERGE (me)-[:USES]->(s_Assembly)
MERGE (s_Thermal_Simulation:Skill {id: "Thermal Simulation"})
MERGE (me)-[:HAS_SKILL]->(s_Thermal_Simulation)
MERGE (me)-[:USES]->(s_Thermal_Simulation)
MERGE (s_ANSYS:Skill {id: "ANSYS"})
MERGE (me)-[:HAS_SKILL]->(s_ANSYS)
MERGE (me)-[:USES]->(s_ANSYS)
MERGE (s_SolidWorks:Skill {id: "SolidWorks"})
MERGE (me)-[:HAS_SKILL]->(s_SolidWorks)
MERGE (me)-[:USES]->(s_SolidWorks)
MERGE (s_Design_for_Manufacturing_DFM:Skill {id: "Design for Manufacturing (DFM)"})
MERGE (me)-[:HAS_SKILL]->(s_Design_for_Manufacturing_DFM)
MERGE (me)-[:USES]->(s_Design_for_Manufacturing_DFM)
MERGE (s_Process_Engineering:Skill {id: "Process Engineering"})
MERGE (me)-[:HAS_SKILL]->(s_Process_Engineering)
MERGE (me)-[:USES]->(s_Process_Engineering)
MERGE (s_AutoCAD:Skill {id: "AutoCAD"})
MERGE (me)-[:HAS_SKILL]->(s_AutoCAD)
MERGE (me)-[:USES]->(s_AutoCAD)
MERGE (s_Road_Design:Skill {id: "Road Design"})
MERGE (me)-[:HAS_SKILL]->(s_Road_Design)
MERGE (me)-[:USES]->(s_Road_Design)
MERGE (s_Geometric_Design:Skill {id: "Geometric Design"})
MERGE (me)-[:HAS_SKILL]->(s_Geometric_Design)
MERGE (me)-[:USES]->(s_Geometric_Design)
MERGE (s_Construction_Documentation:Skill {id: "Construction Documentation"})
MERGE (me)-[:HAS_SKILL]->(s_Construction_Documentation)
MERGE (me)-[:USES]->(s_Construction_Documentation)
MERGE (s_Stakeholder_Coordination:Skill {id: "Stakeholder Coordination"})
MERGE (me)-[:HAS_SKILL]->(s_Stakeholder_Coordination)
MERGE (me)-[:USES]->(s_Stakeholder_Coordination)
MERGE (s_Structural_Design:Skill {id: "Structural Design"})
MERGE (me)-[:HAS_SKILL]->(s_Structural_Design)
MERGE (me)-[:USES]->(s_Structural_Design)
MERGE (s_Building_Code_Compliance:Skill {id: "Building Code Compliance"})
MERGE (me)-[:HAS_SKILL]->(s_Building_Code_Compliance)
MERGE (me)-[:USES]->(s_Building_Code_Compliance)
MERGE (s_Team_Mentoring:Skill {id: "Team Mentoring"})
MERGE (me)-[:HAS_SKILL]->(s_Team_Mentoring)
MERGE (me)-[:USES]->(s_Team_Mentoring)
MERGE (s_Client_Reporting:Skill {id: "Client Reporting"})
MERGE (me)-[:HAS_SKILL]->(s_Client_Reporting)
MERGE (me)-[:USES]->(s_Client_Reporting)
MERGE (s_Sustainability_Integration:Skill {id: "Sustainability Integration"})
MERGE (me)-[:HAS_SKILL]->(s_Sustainability_Integration)
MERGE (me)-[:USES]->(s_Sustainability_Integration)
MERGE (s_Curriculum_Development:Skill {id: "Curriculum Development"})
MERGE (me)-[:HAS_SKILL]->(s_Curriculum_Development)
MERGE (me)-[:USES]->(s_Curriculum_Development)
MERGE (s_Survey_Analysis:Skill {id: "Survey Analysis"})
MERGE (me)-[:HAS_SKILL]->(s_Survey_Analysis)
MERGE (me)-[:USES]->(s_Survey_Analysis)
MERGE (t_SolidWorks:Technology {id: "SolidWorks"})
MERGE (me)-[:USES]->(t_SolidWorks)
MERGE (t_AutoCAD:Technology {id: "AutoCAD"})
MERGE (me)-[:USES]->(t_AutoCAD)
MERGE (t_ANSYS:Technology {id: "ANSYS"})
MERGE (me)-[:USES]->(t_ANSYS)
MERGE (p_Mold_Masters___Automation_Intern:Project {id: "Mold Masters - Automation Intern"})
MERGE (me)-[:DEMONSTRATES]->(p_Mold_Masters___Automation_Intern)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_CAD_Automation)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_Script_Optimization)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_3D_Model_Handling)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_Cross_functional_Collaboration)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_Workflow_Improvement)
MERGE (p_Mold_Masters___Automation_Intern)-[:APPLIES_TO]->(s_Problem_solving)
MERGE (p_Mold_Masters___Automation_Intern)-[:USES]->(t_SolidWorks)
