#include<iostream>
#include<string>

using namespace std;

// Price grades
// Price-Upper limit
int GRADES[6][2] = 
{
	{0, 5},
	{50, 12},
	{200, 19},
	{350, 29},
	{650, 53},
	{1000, 67}
};

#define GRADES_LEN 6

void Process()
{
	int wh_in;
	int duration_Days;
	int duration_DayHours;
	int totalHours;
	float totalkWs;
	int ans;

	printf("----------------------------\n");
	printf("Electricity Usage Calculator\n");
	printf("Mustapha Elmalah\n");
	printf("----------------------------\n");
	printf("What do you want to do?\n\n");
	printf("[1] I know kilo watts consumed, I want to calculate the cost.\n");
	printf("[2] I want to calculate the monthly cost of a specific device.\n");
	printf("\nOption: ");
	cin >> ans;

	if(ans == 1)
	{
		cout << "Enter number of kilo watts consumed: ";
		cin >> totalkWs;
		cout << endl;
	}else if(ans == 2)
	{
		cout << "Enter kWh of your device: ";
		cin >> wh_in;
		cout << endl << "For how many days do you use your device? ";
		cin >> duration_Days;
		cout << endl << "For how many hours per day do you use your device? ";
		cin >> duration_DayHours;
		cout << endl << endl;

		totalHours = duration_Days * duration_DayHours;
		totalkWs = wh_in * totalHours / 1000.00f;
	}else
	{
		cout << "Your input was incorrect." << endl;
		return;
	}

	int totalCents = 0;
	float tmp = totalkWs;
	
	for(int i = 0; i < GRADES_LEN; ++i)
	{
		float amount;
		int kwPrice = GRADES[i][1];

		if((i + 1 ) == GRADES_LEN){
			amount = tmp;
		}else{
			amount = GRADES[i+1][0] - GRADES[i][0];
		}

		totalCents += amount * kwPrice;	
		tmp = tmp - amount;
	}

	printf("-----------------------\n");
	printf("Summary\n");
	printf("-----------------------\n");
	if(ans == 2)
	{
		printf("Usage: %dhours/day, %ddays/month\n", duration_DayHours, duration_Days);
		printf("Total Hours: %d\n", totalHours);
	}
	printf("Total Consumption (kW): %.0f\n", totalkWs);
	printf("Total Cost: %.2f LE\n", totalCents / 100.0f);
	cout << endl;
}
int main()
{
	Process();
	bool retry = false;
	cout << endl << endl << "Would you like to make another calculation? [y/n] ";
	char ans;
	cin >> ans;
	if(ans == 'Y' || ans == 'y')
		Process();
	
	return 0;
}