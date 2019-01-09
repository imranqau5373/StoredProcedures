		


			

			-- get only time attribute questions base on codition of question sub type
			DECLARE @QuestionId INT
	DECLARE listOfQuestionsId CURSOR LOCAL FOR 		
select qq.QuestionId from [dbo].[Questionare] qn
join QuestionareVersion qv on qn.Id = qv.QuestionareId
join  [dbo].[QuestionareQuestion] qq on qn.Id = qq.QuestionareId
inner join [dbo].[Question] as q on qq.questionId = q.id
Where q.questionSubType = 3 and qn.LanguageId =2

OPEN listOfQuestionsId
			FETCH NEXT FROM listOfQuestionsId   
			INTO @QuestionId  
				WHILE @@FETCH_STATUS = 0  
				BEGIN
					print('question id')
					print(@QuestionId)
					DECLARE @VariantId INT
					DECLARE listOfVariants CURSOR LOCAL FOR
					select Id from  QuestionVariant where QuestionId = 	@QuestionId
					OPEN listOfVariants
						FETCH NEXT FROM listOfVariants   
						INTO @VariantId  
						WHILE @@FETCH_STATUS = 0  
						BEGIN
							print('variant id is')
							print(@VariantId)
							declare @VariantCount INT
							set @VariantCount = (select Count(*) from [QuestionVariantResponse] where VariantId = @VariantId)
							print(@VariantCount)
							if(@VariantCount>= 4)
							begin
								DECLARE @ResOptionId INT
								DECLARE @RowCount INT
								set @RowCount = 0
								DECLARE listOfResOption CURSOR LOCAL FOR
								select ResponseoptionId from  [QuestionVariantResponse] where VariantId = @VariantId
								OPEN listOfResOption
								FETCH NEXT FROM listOfResOption   
									INTO @ResOptionId 
								WHILE @@FETCH_STATUS = 0 
								BEGIN
			
									set @RowCount = @RowCount + 1;
							
									if(@RowCount <= 4)
									begin
										print(@ResOptionId)
										update QuestionVariantResponse set Isactive = 0
										--select qro.choiceText,qro.choiceValue,qvr.variantId,qvr.isActive from QuestionVariantResponse qvr
										--left outer join QuestionRespOption qro on 
										--qvr.ResponseOptionId = qro.Id
										where ResponseoptionId = @ResOptionId
									end
								
									FETCH NEXT FROM listOfResOption   
									INTO @ResOptionId
								END
								CLOSE listOfResOption;  
								DEALLOCATE listOfResOption;
		
							end
							FETCH NEXT FROM listOfVariants   
							INTO @VariantId 

						End
						CLOSE listOfVariants;  
						DEALLOCATE listOfVariants; 
					FETCH NEXT FROM listOfQuestionsId   
					INTO @QuestionId  
				END
					CLOSE listOfQuestionsId;  
			DEALLOCATE listOfQuestionsId; 








	