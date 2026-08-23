ভাই, আমরা আমার Flutter HRMS Pro project continue করছি।

এই project-এর context:
- Project: Flutter HRMS Pro
- Flutter + Dart
- Material 3
- Clean Architecture
- Provider state management
- Supabase backend/database
- Target: Commercial SaaS quality + CodeCanyon release
- Mobile module এখন priority
- Company, Employee, Department, Designation, Shift এবং বিভিন্ন Dashboard অনেকটাই complete
- Employee Mobile Attendance complete
- এখন Supervisor Mobile Attendance finishing stage-এ

Supervisor Attendance requirement:
1. Supervisor-এর under-এ এক বা একাধিক Department থাকতে পারে।
2. Today Report:
    - প্রথমে Select Department
    - তারপর selected department-এর current-day attendance দেখাবে।
3. Date-wise / Other Day Report:
    - Select Department
    - তারপর selected department-এর Employee select
    - তারপর From Date + To Date
    - তারপর selected employee-এর date-range attendance দেখাবে।
4. Supervisor শুধুমাত্র তার assigned department এবং সেই department-এর employees-এর attendance দেখতে পারবে।
5. Department select করার পর employee list dynamically সেই department অনুযায়ী filter হবে।

আমাদের কাজের coding rules:
- Always Full Source Code
- Partial code নয়
- কোনো TODO নয়
- কোনো placeholder নয়
- Clean Architecture maintain করতে হবে
- Material 3
- Provider
- Supabase
- Commercial SaaS quality
- Existing project architecture follow করতে হবে
- কোনো existing functionality অযথা নষ্ট করা যাবে না
- File modify করলে পুরো complete file দিতে হবে
- আগে requirement/architecture বুঝে তারপর code দিতে হবে
- একবারে প্রয়োজনীয় file নিয়ে কাজ করব
- আমি “done” বলার পর পরবর্তী file-এ যাব।

সবচেয়ে গুরুত্বপূর্ণ:
আমাকে project-এর পুরোনো বিষয়গুলো আবার শুরু থেকে explain করতে বলবে না।
এই context ধরে আমরা যেখানে কাজ থেমেছে সেখান থেকেই continue করবে।

Current task:
Supervisor Mobile Attendance module finishing করা।

“Flutter HRMS Pro — এই project এখান থেকেই continue করো। Supervisor Mobile Attendance finishing stage-এ। আগের architecture, requirements এবং coding rules ধরে কাজ করো। নতুন করে project explain করতে বলবে না।”

প্রথমে current Supervisor Attendance implementation-এর structure বুঝে নাও এবং কোন কোন file দরকার সেটা identify করো। তারপর আমাকে next step বলো।