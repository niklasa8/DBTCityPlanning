function [Names IDs] = readtest(name)
%Arrays to store values in.
format long
IDs=[];
Names=[];
file_id=fopen(name, 'r', 'n', 'UTF-8'); %Open file.
while ~feof(file_id) %Read until end of file.
    %Read line and split it at tab. The data is stored in a cell array.
    A=strsplit(fgetl(file_id),'\t');
    %Store the values in seperate arrays. Names is a cell array and IDs is
    %a numeric array.
    Names=[Names A(1)];
    IDs=[IDs str2num(A{2})];
end

