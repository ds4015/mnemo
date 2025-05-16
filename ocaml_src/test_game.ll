; ModuleID = 'Mnemo'
source_filename = "Mnemo"

%narr = type { i8*, i8*, i8* }
%item = type { i8*, i8*, i8*, i32, i1, i32, i32, i1 }
%chrctr = type { i8*, i8*, i32, i32, %item* }
%node = type { i8*, i32, i8*, i8*, [256 x { i8*, i32 }]*, i32, i32 }

@narr_arr = global [256 x %narr*] zeroinitializer
@narr_idx = global i32 0
@item_arr = global [256 x %item*] zeroinitializer
@item_idx = global i32 0
@chr_arr = global [256 x %chrctr*] zeroinitializer
@chr_idx = global i32 0
@node_arr = global [256 x %node*] zeroinitializer
@node_idx = global i32 0
@empty_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@dlg = private unnamed_addr constant [12 x i8] c"Hello, Bob.\00", align 1
@lbl = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.1 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@dlg.2 = private unnamed_addr constant [11 x i8] c"Hi, Alice.\00", align 1
@lbl.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.4 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@dlg.5 = private unnamed_addr constant [13 x i8] c"How are you?\00", align 1
@lbl.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.7 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@dlg.8 = private unnamed_addr constant [23 x i8] c"Not bad, and yourself?\00", align 1
@lbl.9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.10 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@dlg.11 = private unnamed_addr constant [11 x i8] c"Fantastic.\00", align 1
@lbl.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.13 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@dlg.14 = private unnamed_addr constant [25 x i8] c"Where do you want to go?\00", align 1
@lbl.15 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@opt_txt = private unnamed_addr constant [7 x i8] c"Desert\00", align 1
@opt_txt.16 = private unnamed_addr constant [7 x i8] c"Forest\00", align 1
@ch.17 = private unnamed_addr constant [7 x i8] c"herder\00", align 1
@dlg.18 = private unnamed_addr constant [32 x i8] c"What!? Where did you come from?\00", align 1
@lbl.19 = private unnamed_addr constant [8 x i8] c"!desert\00", align 1
@ch.20 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@dlg.21 = private unnamed_addr constant [42 x i8] c"Um, I'm not sure. I just teleported here.\00", align 1
@lbl.22 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.23 = private unnamed_addr constant [7 x i8] c"herder\00", align 1
@dlg.24 = private unnamed_addr constant [59 x i8] c"I see. Well, help me with these animals if you don't mind.\00", align 1
@lbl.25 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.26 = private unnamed_addr constant [4 x i8] c"man\00", align 1
@dlg.27 = private unnamed_addr constant [23 x i8] c"Welcome to the forest.\00", align 1
@lbl.28 = private unnamed_addr constant [8 x i8] c"!forest\00", align 1
@ch.29 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@dlg.30 = private unnamed_addr constant [28 x i8] c"Thanks. Where's your shirt?\00", align 1
@lbl.31 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@ch.32 = private unnamed_addr constant [4 x i8] c"man\00", align 1
@dlg.33 = private unnamed_addr constant [44 x i8] c"We don't wear shirts in this humid weather.\00", align 1
@lbl.34 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fmt_node = private unnamed_addr constant [9 x i8] c"%s: %s\0A\0A\00", align 1
@fmt_int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@fmt_bar = private unnamed_addr constant [42 x i8] c"----------------------------------------\0A\00", align 1
@fmt_dialogue = private unnamed_addr constant [8 x i8] c"%s: %s\0A\00", align 1
@fmt_pause = private unnamed_addr constant [30 x i8] c"Press any key to continue...\0A\00", align 1
@fmt_opt_bar = private unnamed_addr constant [42 x i8] c"----------------------------------------\0A\00", align 1
@fmt_opt = private unnamed_addr constant [8 x i8] c"%d: %s\0A\00", align 1
@fmt_int.35 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@fmt_invalid = private unnamed_addr constant [35 x i8] c"Invalid choice. Please try again.\0A\00", align 1

define void @NarrativeTable_add(%narr* %0) {
entry:
  %curr = load i32, i32* @narr_idx, align 4
  %slot = getelementptr inbounds [256 x %narr*], [256 x %narr*]* @narr_arr, i32 0, i32 %curr
  store %narr* %0, %narr** %slot, align 8
  %next = add i32 %curr, 1
  store i32 %next, i32* @narr_idx, align 4
  ret void
}

define void @ItemTable_add(%item* %0) {
entry:
  %curr_idx = load i32, i32* @item_idx, align 4
  %slot = getelementptr inbounds [256 x %item*], [256 x %item*]* @item_arr, i32 0, i32 %curr_idx
  store %item* %0, %item** %slot, align 8
  %next_idx = add i32 %curr_idx, 1
  store i32 %next_idx, i32* @item_idx, align 4
  ret void
}

define void @CharacterTable_add(%chrctr* %0) {
entry:
  %curr_idx = load i32, i32* @chr_idx, align 4
  %slot = getelementptr inbounds [256 x %chrctr*], [256 x %chrctr*]* @chr_arr, i32 0, i32 %curr_idx
  store %chrctr* %0, %chrctr** %slot, align 8
  %next_idx = add i32 %curr_idx, 1
  store i32 %next_idx, i32* @chr_idx, align 4
  ret void
}

define void @NodeTable_add(%node* %0) {
entry:
  %curr_idx = load i32, i32* @node_idx, align 4
  %slot = getelementptr inbounds [256 x %node*], [256 x %node*]* @node_arr, i32 0, i32 %curr_idx
  store %node* %0, %node** %slot, align 8
  %next_idx = add i32 %curr_idx, 1
  store i32 %next_idx, i32* @node_idx, align 4
  ret void
}

define i32 @main() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr = bitcast i8* %malloccall to [256 x { i8*, i32 }]*
  %array_ptr = bitcast [256 x { i8*, i32 }]* %opts_arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr, i8 0, i64 4096, i1 false)
  %malloccall1 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node = bitcast i8* %malloccall1 to %node*
  %field = getelementptr inbounds %node, %node* %node, i32 0, i32 0
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @ch, i32 0, i32 0), i8** %field, align 8
  %field2 = getelementptr inbounds %node, %node* %node, i32 0, i32 1
  store i32 0, i32* %field2, align 4
  %field3 = getelementptr inbounds %node, %node* %node, i32 0, i32 2
  store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @dlg, i32 0, i32 0), i8** %field3, align 8
  %field4 = getelementptr inbounds %node, %node* %node, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl, i32 0, i32 0), i8** %field4, align 8
  %field5 = getelementptr inbounds %node, %node* %node, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr, [256 x { i8*, i32 }]** %field5, align 8
  %field6 = getelementptr inbounds %node, %node* %node, i32 0, i32 5
  store i32 0, i32* %field6, align 4
  %field7 = getelementptr inbounds %node, %node* %node, i32 0, i32 6
  store i32 1, i32* %field7, align 4
  call void @NodeTable_add(%node* %node)
  %malloccall8 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr9 = bitcast i8* %malloccall8 to [256 x { i8*, i32 }]*
  %array_ptr10 = bitcast [256 x { i8*, i32 }]* %opts_arr9 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr10, i8 0, i64 4096, i1 false)
  %malloccall11 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node12 = bitcast i8* %malloccall11 to %node*
  %field13 = getelementptr inbounds %node, %node* %node12, i32 0, i32 0
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ch.1, i32 0, i32 0), i8** %field13, align 8
  %field14 = getelementptr inbounds %node, %node* %node12, i32 0, i32 1
  store i32 1, i32* %field14, align 4
  %field15 = getelementptr inbounds %node, %node* %node12, i32 0, i32 2
  store i8* getelementptr inbounds ([11 x i8], [11 x i8]* @dlg.2, i32 0, i32 0), i8** %field15, align 8
  %field16 = getelementptr inbounds %node, %node* %node12, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.3, i32 0, i32 0), i8** %field16, align 8
  %field17 = getelementptr inbounds %node, %node* %node12, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr9, [256 x { i8*, i32 }]** %field17, align 8
  %field18 = getelementptr inbounds %node, %node* %node12, i32 0, i32 5
  store i32 0, i32* %field18, align 4
  %field19 = getelementptr inbounds %node, %node* %node12, i32 0, i32 6
  store i32 2, i32* %field19, align 4
  call void @NodeTable_add(%node* %node12)
  %malloccall20 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr21 = bitcast i8* %malloccall20 to [256 x { i8*, i32 }]*
  %array_ptr22 = bitcast [256 x { i8*, i32 }]* %opts_arr21 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr22, i8 0, i64 4096, i1 false)
  %malloccall23 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node24 = bitcast i8* %malloccall23 to %node*
  %field25 = getelementptr inbounds %node, %node* %node24, i32 0, i32 0
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @ch.4, i32 0, i32 0), i8** %field25, align 8
  %field26 = getelementptr inbounds %node, %node* %node24, i32 0, i32 1
  store i32 2, i32* %field26, align 4
  %field27 = getelementptr inbounds %node, %node* %node24, i32 0, i32 2
  store i8* getelementptr inbounds ([13 x i8], [13 x i8]* @dlg.5, i32 0, i32 0), i8** %field27, align 8
  %field28 = getelementptr inbounds %node, %node* %node24, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.6, i32 0, i32 0), i8** %field28, align 8
  %field29 = getelementptr inbounds %node, %node* %node24, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr21, [256 x { i8*, i32 }]** %field29, align 8
  %field30 = getelementptr inbounds %node, %node* %node24, i32 0, i32 5
  store i32 0, i32* %field30, align 4
  %field31 = getelementptr inbounds %node, %node* %node24, i32 0, i32 6
  store i32 3, i32* %field31, align 4
  call void @NodeTable_add(%node* %node24)
  %malloccall32 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr33 = bitcast i8* %malloccall32 to [256 x { i8*, i32 }]*
  %array_ptr34 = bitcast [256 x { i8*, i32 }]* %opts_arr33 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr34, i8 0, i64 4096, i1 false)
  %malloccall35 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node36 = bitcast i8* %malloccall35 to %node*
  %field37 = getelementptr inbounds %node, %node* %node36, i32 0, i32 0
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ch.7, i32 0, i32 0), i8** %field37, align 8
  %field38 = getelementptr inbounds %node, %node* %node36, i32 0, i32 1
  store i32 3, i32* %field38, align 4
  %field39 = getelementptr inbounds %node, %node* %node36, i32 0, i32 2
  store i8* getelementptr inbounds ([23 x i8], [23 x i8]* @dlg.8, i32 0, i32 0), i8** %field39, align 8
  %field40 = getelementptr inbounds %node, %node* %node36, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.9, i32 0, i32 0), i8** %field40, align 8
  %field41 = getelementptr inbounds %node, %node* %node36, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr33, [256 x { i8*, i32 }]** %field41, align 8
  %field42 = getelementptr inbounds %node, %node* %node36, i32 0, i32 5
  store i32 0, i32* %field42, align 4
  %field43 = getelementptr inbounds %node, %node* %node36, i32 0, i32 6
  store i32 4, i32* %field43, align 4
  call void @NodeTable_add(%node* %node36)
  %malloccall44 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr45 = bitcast i8* %malloccall44 to [256 x { i8*, i32 }]*
  %array_ptr46 = bitcast [256 x { i8*, i32 }]* %opts_arr45 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr46, i8 0, i64 4096, i1 false)
  %malloccall47 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node48 = bitcast i8* %malloccall47 to %node*
  %field49 = getelementptr inbounds %node, %node* %node48, i32 0, i32 0
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @ch.10, i32 0, i32 0), i8** %field49, align 8
  %field50 = getelementptr inbounds %node, %node* %node48, i32 0, i32 1
  store i32 4, i32* %field50, align 4
  %field51 = getelementptr inbounds %node, %node* %node48, i32 0, i32 2
  store i8* getelementptr inbounds ([11 x i8], [11 x i8]* @dlg.11, i32 0, i32 0), i8** %field51, align 8
  %field52 = getelementptr inbounds %node, %node* %node48, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.12, i32 0, i32 0), i8** %field52, align 8
  %field53 = getelementptr inbounds %node, %node* %node48, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr45, [256 x { i8*, i32 }]** %field53, align 8
  %field54 = getelementptr inbounds %node, %node* %node48, i32 0, i32 5
  store i32 0, i32* %field54, align 4
  %field55 = getelementptr inbounds %node, %node* %node48, i32 0, i32 6
  store i32 5, i32* %field55, align 4
  call void @NodeTable_add(%node* %node48)
  %malloccall56 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr57 = bitcast i8* %malloccall56 to [256 x { i8*, i32 }]*
  %array_ptr58 = bitcast [256 x { i8*, i32 }]* %opts_arr57 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr58, i8 0, i64 4096, i1 false)
  %opt_elem0 = getelementptr inbounds [256 x { i8*, i32 }], [256 x { i8*, i32 }]* %opts_arr57, i32 0, i32 0
  %f0 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %opt_elem0, i32 0, i32 0
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @opt_txt, i32 0, i32 0), i8** %f0, align 8
  %f1 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %opt_elem0, i32 0, i32 1
  store i32 6, i32* %f1, align 4
  %opt_elem1 = getelementptr inbounds [256 x { i8*, i32 }], [256 x { i8*, i32 }]* %opts_arr57, i32 0, i32 1
  %f059 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %opt_elem1, i32 0, i32 0
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @opt_txt.16, i32 0, i32 0), i8** %f059, align 8
  %f160 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %opt_elem1, i32 0, i32 1
  store i32 9, i32* %f160, align 4
  %malloccall61 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node62 = bitcast i8* %malloccall61 to %node*
  %field63 = getelementptr inbounds %node, %node* %node62, i32 0, i32 0
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ch.13, i32 0, i32 0), i8** %field63, align 8
  %field64 = getelementptr inbounds %node, %node* %node62, i32 0, i32 1
  store i32 5, i32* %field64, align 4
  %field65 = getelementptr inbounds %node, %node* %node62, i32 0, i32 2
  store i8* getelementptr inbounds ([25 x i8], [25 x i8]* @dlg.14, i32 0, i32 0), i8** %field65, align 8
  %field66 = getelementptr inbounds %node, %node* %node62, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.15, i32 0, i32 0), i8** %field66, align 8
  %field67 = getelementptr inbounds %node, %node* %node62, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr57, [256 x { i8*, i32 }]** %field67, align 8
  %field68 = getelementptr inbounds %node, %node* %node62, i32 0, i32 5
  store i32 2, i32* %field68, align 4
  %field69 = getelementptr inbounds %node, %node* %node62, i32 0, i32 6
  store i32 6, i32* %field69, align 4
  call void @NodeTable_add(%node* %node62)
  %malloccall70 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr71 = bitcast i8* %malloccall70 to [256 x { i8*, i32 }]*
  %array_ptr72 = bitcast [256 x { i8*, i32 }]* %opts_arr71 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr72, i8 0, i64 4096, i1 false)
  %malloccall73 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node74 = bitcast i8* %malloccall73 to %node*
  %field75 = getelementptr inbounds %node, %node* %node74, i32 0, i32 0
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @ch.17, i32 0, i32 0), i8** %field75, align 8
  %field76 = getelementptr inbounds %node, %node* %node74, i32 0, i32 1
  store i32 6, i32* %field76, align 4
  %field77 = getelementptr inbounds %node, %node* %node74, i32 0, i32 2
  store i8* getelementptr inbounds ([32 x i8], [32 x i8]* @dlg.18, i32 0, i32 0), i8** %field77, align 8
  %field78 = getelementptr inbounds %node, %node* %node74, i32 0, i32 3
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @lbl.19, i32 0, i32 0), i8** %field78, align 8
  %field79 = getelementptr inbounds %node, %node* %node74, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr71, [256 x { i8*, i32 }]** %field79, align 8
  %field80 = getelementptr inbounds %node, %node* %node74, i32 0, i32 5
  store i32 0, i32* %field80, align 4
  %field81 = getelementptr inbounds %node, %node* %node74, i32 0, i32 6
  store i32 7, i32* %field81, align 4
  call void @NodeTable_add(%node* %node74)
  %malloccall82 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr83 = bitcast i8* %malloccall82 to [256 x { i8*, i32 }]*
  %array_ptr84 = bitcast [256 x { i8*, i32 }]* %opts_arr83 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr84, i8 0, i64 4096, i1 false)
  %malloccall85 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node86 = bitcast i8* %malloccall85 to %node*
  %field87 = getelementptr inbounds %node, %node* %node86, i32 0, i32 0
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @ch.20, i32 0, i32 0), i8** %field87, align 8
  %field88 = getelementptr inbounds %node, %node* %node86, i32 0, i32 1
  store i32 7, i32* %field88, align 4
  %field89 = getelementptr inbounds %node, %node* %node86, i32 0, i32 2
  store i8* getelementptr inbounds ([42 x i8], [42 x i8]* @dlg.21, i32 0, i32 0), i8** %field89, align 8
  %field90 = getelementptr inbounds %node, %node* %node86, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.22, i32 0, i32 0), i8** %field90, align 8
  %field91 = getelementptr inbounds %node, %node* %node86, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr83, [256 x { i8*, i32 }]** %field91, align 8
  %field92 = getelementptr inbounds %node, %node* %node86, i32 0, i32 5
  store i32 0, i32* %field92, align 4
  %field93 = getelementptr inbounds %node, %node* %node86, i32 0, i32 6
  store i32 8, i32* %field93, align 4
  call void @NodeTable_add(%node* %node86)
  %malloccall94 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr95 = bitcast i8* %malloccall94 to [256 x { i8*, i32 }]*
  %array_ptr96 = bitcast [256 x { i8*, i32 }]* %opts_arr95 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr96, i8 0, i64 4096, i1 false)
  %malloccall97 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node98 = bitcast i8* %malloccall97 to %node*
  %field99 = getelementptr inbounds %node, %node* %node98, i32 0, i32 0
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @ch.23, i32 0, i32 0), i8** %field99, align 8
  %field100 = getelementptr inbounds %node, %node* %node98, i32 0, i32 1
  store i32 8, i32* %field100, align 4
  %field101 = getelementptr inbounds %node, %node* %node98, i32 0, i32 2
  store i8* getelementptr inbounds ([59 x i8], [59 x i8]* @dlg.24, i32 0, i32 0), i8** %field101, align 8
  %field102 = getelementptr inbounds %node, %node* %node98, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.25, i32 0, i32 0), i8** %field102, align 8
  %field103 = getelementptr inbounds %node, %node* %node98, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr95, [256 x { i8*, i32 }]** %field103, align 8
  %field104 = getelementptr inbounds %node, %node* %node98, i32 0, i32 5
  store i32 0, i32* %field104, align 4
  %field105 = getelementptr inbounds %node, %node* %node98, i32 0, i32 6
  store i32 9, i32* %field105, align 4
  call void @NodeTable_add(%node* %node98)
  %malloccall106 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr107 = bitcast i8* %malloccall106 to [256 x { i8*, i32 }]*
  %array_ptr108 = bitcast [256 x { i8*, i32 }]* %opts_arr107 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr108, i8 0, i64 4096, i1 false)
  %malloccall109 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node110 = bitcast i8* %malloccall109 to %node*
  %field111 = getelementptr inbounds %node, %node* %node110, i32 0, i32 0
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ch.26, i32 0, i32 0), i8** %field111, align 8
  %field112 = getelementptr inbounds %node, %node* %node110, i32 0, i32 1
  store i32 9, i32* %field112, align 4
  %field113 = getelementptr inbounds %node, %node* %node110, i32 0, i32 2
  store i8* getelementptr inbounds ([23 x i8], [23 x i8]* @dlg.27, i32 0, i32 0), i8** %field113, align 8
  %field114 = getelementptr inbounds %node, %node* %node110, i32 0, i32 3
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @lbl.28, i32 0, i32 0), i8** %field114, align 8
  %field115 = getelementptr inbounds %node, %node* %node110, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr107, [256 x { i8*, i32 }]** %field115, align 8
  %field116 = getelementptr inbounds %node, %node* %node110, i32 0, i32 5
  store i32 0, i32* %field116, align 4
  %field117 = getelementptr inbounds %node, %node* %node110, i32 0, i32 6
  store i32 10, i32* %field117, align 4
  call void @NodeTable_add(%node* %node110)
  %malloccall118 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr119 = bitcast i8* %malloccall118 to [256 x { i8*, i32 }]*
  %array_ptr120 = bitcast [256 x { i8*, i32 }]* %opts_arr119 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr120, i8 0, i64 4096, i1 false)
  %malloccall121 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node122 = bitcast i8* %malloccall121 to %node*
  %field123 = getelementptr inbounds %node, %node* %node122, i32 0, i32 0
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @ch.29, i32 0, i32 0), i8** %field123, align 8
  %field124 = getelementptr inbounds %node, %node* %node122, i32 0, i32 1
  store i32 10, i32* %field124, align 4
  %field125 = getelementptr inbounds %node, %node* %node122, i32 0, i32 2
  store i8* getelementptr inbounds ([28 x i8], [28 x i8]* @dlg.30, i32 0, i32 0), i8** %field125, align 8
  %field126 = getelementptr inbounds %node, %node* %node122, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.31, i32 0, i32 0), i8** %field126, align 8
  %field127 = getelementptr inbounds %node, %node* %node122, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr119, [256 x { i8*, i32 }]** %field127, align 8
  %field128 = getelementptr inbounds %node, %node* %node122, i32 0, i32 5
  store i32 0, i32* %field128, align 4
  %field129 = getelementptr inbounds %node, %node* %node122, i32 0, i32 6
  store i32 11, i32* %field129, align 4
  call void @NodeTable_add(%node* %node122)
  %malloccall130 = tail call i8* @malloc(i32 ptrtoint ([256 x { i8*, i32 }]* getelementptr ([256 x { i8*, i32 }], [256 x { i8*, i32 }]* null, i32 1) to i32))
  %opts_arr131 = bitcast i8* %malloccall130 to [256 x { i8*, i32 }]*
  %array_ptr132 = bitcast [256 x { i8*, i32 }]* %opts_arr131 to i8*
  call void @llvm.memset.p0i8.i64(i8* %array_ptr132, i8 0, i64 4096, i1 false)
  %malloccall133 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %node134 = bitcast i8* %malloccall133 to %node*
  %field135 = getelementptr inbounds %node, %node* %node134, i32 0, i32 0
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ch.32, i32 0, i32 0), i8** %field135, align 8
  %field136 = getelementptr inbounds %node, %node* %node134, i32 0, i32 1
  store i32 11, i32* %field136, align 4
  %field137 = getelementptr inbounds %node, %node* %node134, i32 0, i32 2
  store i8* getelementptr inbounds ([44 x i8], [44 x i8]* @dlg.33, i32 0, i32 0), i8** %field137, align 8
  %field138 = getelementptr inbounds %node, %node* %node134, i32 0, i32 3
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @lbl.34, i32 0, i32 0), i8** %field138, align 8
  %field139 = getelementptr inbounds %node, %node* %node134, i32 0, i32 4
  store [256 x { i8*, i32 }]* %opts_arr131, [256 x { i8*, i32 }]** %field139, align 8
  %field140 = getelementptr inbounds %node, %node* %node134, i32 0, i32 5
  store i32 0, i32* %field140, align 4
  %field141 = getelementptr inbounds %node, %node* %node134, i32 0, i32 6
  store i32 12, i32* %field141, align 4
  call void @NodeTable_add(%node* %node134)
  %runcall = call i32 @run()
  ret i32 0
}

declare noalias i8* @malloc(i32)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @scanf(i8*, ...)

declare i32 @getchar()

define i32 @run() {
entry:
  %count = load i32, i32* @node_idx, align 4
  %cur = alloca i32, align 4
  store i32 0, i32* %cur, align 4
  br label %loop.head

loop.head:                                        ; preds = %no_opts, %valid_choice4, %entry
  %cur1 = load i32, i32* %cur, align 4
  %cond = icmp slt i32 %cur1, %count
  br i1 %cond, label %loop.body, label %loop.exit

loop.body:                                        ; preds = %loop.head
  %node_ptr_ptr = getelementptr inbounds [256 x %node*], [256 x %node*]* @node_arr, i32 0, i32 %cur1
  %node_ptr = load %node*, %node** %node_ptr_ptr, align 8
  %ch_ptr = getelementptr inbounds %node, %node* %node_ptr, i32 0, i32 0
  %ch = load i8*, i8** %ch_ptr, align 8
  %dlg_ptr = getelementptr inbounds %node, %node* %node_ptr, i32 0, i32 2
  %dlg = load i8*, i8** %dlg_ptr, align 8
  %num_opts_ptr = getelementptr inbounds %node, %node* %node_ptr, i32 0, i32 5
  %num_opts = load i32, i32* %num_opts_ptr, align 4
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @fmt_bar, i32 0, i32 0))
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @fmt_dialogue, i32 0, i32 0), i8* %ch, i8* %dlg)
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @fmt_bar, i32 0, i32 0))
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @fmt_pause, i32 0, i32 0))
  %4 = call i32 @getchar()
  %has_opts = icmp sgt i32 %num_opts, 0
  br i1 %has_opts, label %opts, label %no_opts

loop.exit:                                        ; preds = %loop.head
  ret i32 0

opts:                                             ; preds = %loop.body
  %opts_ptr = getelementptr inbounds %node, %node* %node_ptr, i32 0, i32 4
  %opts2 = load [256 x { i8*, i32 }]*, [256 x { i8*, i32 }]** %opts_ptr, align 8
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @fmt_opt_bar, i32 0, i32 0))
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %opt_loop_head

no_opts:                                          ; preds = %loop.body
  %next_ptr = getelementptr inbounds %node, %node* %node_ptr, i32 0, i32 6
  %next_id5 = load i32, i32* %next_ptr, align 4
  store i32 %next_id5, i32* %cur, align 4
  br label %loop.head

opt_loop_head:                                    ; preds = %invalid_choice, %opt_loop_body, %opts
  %i3 = load i32, i32* %i, align 4
  %opt_cond = icmp slt i32 %i3, %num_opts
  br i1 %opt_cond, label %opt_loop_body, label %opt_loop_exit

opt_loop_body:                                    ; preds = %opt_loop_head
  %opt_elem = getelementptr inbounds [256 x { i8*, i32 }], [256 x { i8*, i32 }]* %opts2, i32 0, i32 %i3
  %opt_text_ptr = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %opt_elem, i32 0, i32 0
  %opt_text = load i8*, i8** %opt_text_ptr, align 8
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @fmt_opt, i32 0, i32 0), i32 %i3, i8* %opt_text)
  %next_i = add i32 %i3, 1
  store i32 %next_i, i32* %i, align 4
  br label %opt_loop_head

opt_loop_exit:                                    ; preds = %opt_loop_head
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @fmt_opt_bar, i32 0, i32 0))
  %choice_ptr = alloca i32, align 4
  %8 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @fmt_int.35, i32 0, i32 0), i32* %choice_ptr)
  %choice = load i32, i32* %choice_ptr, align 4
  %valid_choice = icmp slt i32 %choice, %num_opts
  br i1 %valid_choice, label %valid_choice4, label %invalid_choice

invalid_choice:                                   ; preds = %opt_loop_exit
  %9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @fmt_invalid, i32 0, i32 0))
  br label %opt_loop_head

valid_choice4:                                    ; preds = %opt_loop_exit
  %chosen_opt = getelementptr inbounds [256 x { i8*, i32 }], [256 x { i8*, i32 }]* %opts2, i32 0, i32 %choice
  %next_id_ptr = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %chosen_opt, i32 0, i32 1
  %next_id = load i32, i32* %next_id_ptr, align 4
  store i32 %next_id, i32* %cur, align 4
  br label %loop.head
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
