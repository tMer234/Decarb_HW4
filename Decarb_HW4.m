%% Problem 1

%define all the known values given in the problem
stream_1_temp = 50; %degrees Celsius
stream_1_m_dot = 200; %kg/min
stream_1_spec_enth = 209.3; %kJ/kg
Q_dot = 1.26*10^5; %kJ/min
stream_2_temp = 100; %degrees Celsius
stream_2_spec_enth = 419.1; %kJ/kg
stream_3_temp = 100; %degrees Celsius
stream_3_spec_enth = 2676; %kJ/kg

%create symbolic variables and equations to solve
syms Q_dot_equation M_dot_equation stream_2_m_dot stream_3_m_dot

%the general balance equation in this case becomes to Q dot = delta H dot
%delta H dot is the rate of change in enthalpy between the input and output streams
%given that rate of enthalpy change is equal to mass flow rate times specific enthalpy
%H dot out is equal to the stream 2's mass flow rate times its specific
%enthalpy plus stream 3's mass flow rate times its specific enthalpy
%H dot in is equal to stream's mass flow rate times its specific enthalpy
Q_dot_equation = (stream_2_m_dot*stream_2_spec_enth + stream_3_m_dot*stream_3_spec_enth) - (stream_1_m_dot*stream_1_spec_enth) == Q_dot;
%the second equation accounts for the conservation of mass flow
%the total flow rate out needs to be the same as the total flow rate in
M_dot_equation = stream_2_m_dot + stream_3_m_dot == stream_1_m_dot;

%solve the equation
solution = solve([Q_dot_equation, M_dot_equation], [stream_2_m_dot, stream_3_m_dot]);

%display results
fprintf("1.a) Stream 2 Mass Flow Rate: %.3f g/s \n", solution.stream_2_m_dot)
fprintf("1.a) Stream 3 Mass Flow Rate: %.3f g/s \n", solution.stream_3_m_dot)


%create symbolic variable to solve for
syms Q_dot_max

%set stream_3 m dot equal to stream_1 m dot
%since if 100% of water is boiled, the mass flow rate of steam out will be the same
%as the mass flow of water in
stream_3_m_dot_max = stream_1_m_dot;

%rearrange the equation solving for the value of Q_dot when 100% of water
%is boiled by solving for Q_dot plus the product of stream 1's mass flow
%rate and its specific enthalpy when it is equal to the product of stream
%3's mass flow rate and its specific enthalpy
Q_dot_max_eqn = Q_dot_max + stream_1_m_dot*stream_1_spec_enth == stream_3_m_dot_max*stream_3_spec_enth;

%solve equation for Q_dot
Q_dot = solve(Q_dot_max_eqn, Q_dot_max);
%divide Q dot by .06 to convert from kJ/min to Watts
Q_dot  = Q_dot / .06; % 1W = .06 kJ/min
%display results
fprintf("1.b) Energy Needed to Boil 100%% of Incoming Water: %.3e W\n", Q_dot);

%% Problem 2

m_dot_NH3 = 175*10^6; %175m tonnes/yr
%365 days per year, 24 hours per day, 60 mins per hour, 60 seconds per min,
% 1000 kg per tonne, 1000 g per kg
conversion_factor = 365*24*60*60/(1000*1000);
%conversion to g/s
m_dot_NH3 = m_dot_NH3/conversion_factor;
%conversion to mol/s
N_dot_NH3 = m_dot_NH3 / 17.031; % divide 17.031 g/mol (molar mass of NH3)
N_dot_H2 = N_dot_NH3 * (3/2); %multiply by molar ratio of H2 to NH3 in Haber-Bosch reaction

%gray H2 accounts for 90 percent of total H2 usage
N_dot_grayH2 = N_dot_H2 * .9; %mol/s
%multiply by molar mass of H2
M_dot_grayH2 = N_dot_grayH2*2.016; %g/s

fprintf("2.a) Required mass flow rate of gray H2: %.3e g/s \n", M_dot_grayH2);

%divide by stoichometric coefficient of 4 to get rate of reaction
r4 = N_dot_grayH2/4; %mol/s

fprintf("2.b) Net rate of reaction r4: %.3e mol/s \n", r4);


%Molar flow rate of CO2 will be equal to the rate of reaction because the
%stoichometric coefficient of CO2 is 1
N_dot_CO2 = r4;
%multiply molar flow rate of CO2 by molar mass of CO2 to get mass flow rate
M_dot_CO2 = N_dot_CO2 * 44.01; %g/s

fprintf("2.c) Mass flow rate of CO2 from reaction r4: %.3e g/s \n", M_dot_CO2);

delta_H_r4 = 165; %kJ/mol
Q_dot_gray = r4*delta_H_r4; %kJ/s
% 1 kJ/s = 1000 W
fprintf("2.d) required heating rate gray: %.3e W \n", Q_dot_gray * 1000);

syms r5

%gray hydrogen reactor system is endothermic, so the combustor is
%exothermic
Q_dot_gray_combustor = -Q_dot_gray;
efficiency = .85;
delta_H_combustion = -803;
%product of efficiency, rate of reaction and delta H gives Q dot
Q_dot_combustor_eqn = efficiency * r5 *  delta_H_combustion == Q_dot_gray_combustor;

r5 = solve(Q_dot_combustor_eqn, r5);

%molar flow rate of CO2 will be equal to the rate of reaction because the
%stoichometric coefficient of CO2 is 1
n_dot_CO2_combustion = r5;
%multiply molar flow rate of CO2 by molar mass of CO2 to get mass flow rate
M_dot_CO2_combustion = n_dot_CO2_combustion*44.01;

fprintf("2.e) mass flow rate of CO2 produced by r5: %.3e \n", M_dot_CO2_combustion);

%total CO2 production 
M_dot_CO2_total = M_dot_CO2_combustion + M_dot_CO2; %g/s
%convert from g/s to kg/yr
%60 sec per min, 60 min per hour, 24 hour per day, 365 day per year, and
%1000 kg/g
M_dot_CO2_total = M_dot_CO2_total * 60*60*24*365/1000;

fprintf("2.f) Total CO2 production rate: %.3e kg/yr \n", M_dot_CO2_total);

%% Problem 3

%10% of H2 production is turquoise
N_dot_turqH2 = .1*N_dot_H2; %mol/s  
%multiply by molar mass of H2 to get mass flow rate
M_dot_turqH2 = N_dot_turqH2*2.016; %g/s

fprintf("3.a) Required mass flow rate of turquoise H2: %.3e g/s \n", M_dot_turqH2);

%stoichometric coefficient of hydrogen in methane pyrolysis (Turqouise H2 proudction) is 2 
r3 = N_dot_turqH2/2;

fprintf("3.b) net rate of reaction r3: %.3e mol/s \n", r3)

%stoichiometric coefficient of solid Carbon product is 1, so molar flow rate of solid Carbon is equal to rate of reaction 
N_dot_Cs = r3;
%multiply by molar mass of Carbon to get mass flow rate
M_dot_Cs = N_dot_Cs * 12.011; %g/s

fprintf("3.c) mass flow rate of C(s) that is produced as part of r: %.3e g/s \n", M_dot_Cs);

delta_H_r3 = 75; %kJ/mol
Q_dot_r3 = r3 * delta_H_r3; %kJ/s

%multiply by 1000 as 1 kJ/s = 1000 W
fprintf("3.d) required heating rate Turquoise: %.3e W \n", Q_dot_r3*1000);

%turquoise hydrogen reactor system is endothermic, so the combustor is
%exothermic, equal to the opposite of the thermal requirements 
Q_dot_turq_combustor = -Q_dot_r3;
syms r5_turquoise

%product of efficiency, rate of reaction and delta H gives Q dot
Q_dot_turq_combustor_eqn = .85 * r5_turquoise * delta_H_combustion == Q_dot_turq_combustor;

%solve equation for rate of combustion reaction required for turquoise H2
%production
r5_turquoise = solve(Q_dot_turq_combustor_eqn, r5_turquoise);

%stoichiometric coefficient of CO2 in combustion reaction is one so molar flow rate is equal to rate of reaciton 
n_dot_CO2_turq_combustion = r5_turquoise;

%multiply by molar mass of CO2 to get mass flow rate
M_dot_CO2_turq_combustion = n_dot_CO2_turq_combustion * 44.01;

fprintf("3.e) mass flow rate of CO2 produced by r5 for turquoise H2: %.3e g/s \n", M_dot_CO2_combustion);

%combustion releases CO2, pyrolysis only produces solid carbon
%multiply by 60 seconds/min, 60 mins/hr, 24 hrs/day, 365 days/yr, divide by
%1000 g/kg to get total in kg/yr
M_dot_CO2_turq_total = M_dot_CO2_turq_combustion * 60*60*24*365/1000; %kg/yr

fprintf("3.f) Total CO2 production rate Turquoise: %.3e kg/yr \n", M_dot_CO2_turq_total);
